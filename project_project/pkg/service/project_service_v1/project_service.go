package project_service_v1

import (
	"context"
	"fmt"
	"github.com/jinzhu/copier"
	"go.uber.org/zap"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_common/tms"
	"go_project/ms_project/project_grpc/project"
	"go_project/ms_project/project_grpc/user/login"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/data/menu"
	"go_project/ms_project/project_project/internal/data/pro"
	"go_project/ms_project/project_project/internal/data/task"
	"go_project/ms_project/project_project/internal/database"
	"go_project/ms_project/project_project/internal/database/tran"
	"go_project/ms_project/project_project/internal/repo"
	"go_project/ms_project/project_project/internal/rpc"
	"go_project/ms_project/project_project/pkg/model"
	"strconv"
	"time"
)

type ProjectService struct {
	project.UnimplementedProjectServiceServer
	cache                  repo.Cache
	transaction            tran.Transaction
	menuRepo               repo.MenuRepo
	projectRepo            repo.ProjectRepo
	projectTemplateRepo    repo.ProjectTemplateRepo
	taskStagesTemplateRepo repo.TaskStagesTemplateRepo
}

func New() *ProjectService {
	return &ProjectService{
		cache:                  dao.Rc,
		transaction:            dao.NewTransaction(),
		menuRepo:               dao.NewMenuDao(),
		projectRepo:            dao.NewProjectDao(),
		projectTemplateRepo:    dao.NewProjectTemplateDao(),
		taskStagesTemplateRepo: dao.NewTaskStagesTemplateDao(),
	}
}

func (p *ProjectService) Index(context.Context, *project.IndexMessage) (*project.IndexResponse, error) {
	pms, err := p.menuRepo.FindMenus(context.Background())
	if err != nil {
		zap.L().Error("Index db FindMenus error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	childs := menu.CovertChild(pms)
	var mms []*project.MenuMessage
	copier.Copy(&mms, childs)
	return &project.IndexResponse{Menus: mms}, nil
}

func (p *ProjectService) FindProjectByMemId(ctx context.Context, msg *project.ProjectRpcMessage) (*project.MyProjectResponse, error) {
	memberId := msg.MemberId
	page := msg.Page
	pageSize := msg.PageSize
	var pms []*pro.ProjectAndMember
	var total int64
	var err error
	if msg.SelectBy == "" || msg.SelectBy == "my" {
		pms, total, err = p.projectRepo.FindProjectByMemId(ctx, memberId, "and deleted=0 ", page, pageSize)
	}
	if msg.SelectBy == "archive" {
		pms, total, err = p.projectRepo.FindProjectByMemId(ctx, memberId, "and archive=1 ", page, pageSize)
	}
	if msg.SelectBy == "deleted" {
		pms, total, err = p.projectRepo.FindProjectByMemId(ctx, memberId, "and deleted=1 ", page, pageSize)
	}
	if msg.SelectBy == "collect" {
		pms, total, err = p.projectRepo.FindCollectProjectByMemId(ctx, memberId, page, pageSize)
		for _, v := range pms {
			v.Collected = model.Collected
		}
	} else {
		collectPms, _, err := p.projectRepo.FindCollectProjectByMemId(ctx, memberId, page, pageSize)
		if err != nil {
			zap.L().Error("FindProjectByMemId db FindCollectProjectByMemId error", zap.Error(err))
			return nil, errs.GrpcError(model.DBError)
		}
		var cMap = make(map[int64]*pro.ProjectAndMember)
		for _, v := range collectPms {
			cMap[v.Id] = v
			//fmt.Println("collectPms:", v.Id, v.Name, v.ProjectCode)
		}
		for _, v := range pms {
			//fmt.Println("pms:", v.Id, v.Name, v.ProjectCode)
			if cMap[v.Id] != nil {
				v.Collected = model.Collected
			}
		}
	}
	if err != nil {
		zap.L().Error("FindProjectByMemId db error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if pms == nil {
		return &project.MyProjectResponse{Total: total, Pm: []*project.ProjectMessage{}}, nil
	}

	var pmm []*project.ProjectMessage
	copier.Copy(&pmm, pms)
	for _, v := range pmm {
		v.Code, _ = encrypts.EncryptInt64(v.ProjectCode, model.AESKey)
		pam := pro.ToMap(pms)[v.Id]
		v.AccessControlType = pam.GetAccessControlType()
		v.OrganizationCode, _ = encrypts.EncryptInt64(pam.OrganizationCode, model.AESKey)
		v.JoinTime = tms.FormatByMill(pam.JoinTime)
		v.OwnerName = msg.MemberName
		v.Order = int32(pam.Sort)
		v.CreateTime = tms.FormatByMill(pam.CreateTime)
	}
	return &project.MyProjectResponse{Pm: pmm, Total: total}, nil
}

func (ps *ProjectService) FindProjectTemplate(ctx context.Context, msg *project.ProjectRpcMessage) (*project.ProjectTemplateResponse, error) {
	//根据viewType查询项目模板表
	organizationCodeStr, _ := encrypts.Decrypt(msg.OrganizationCode, model.AESKey)
	organizationCode, _ := strconv.ParseInt(organizationCodeStr, 10, 64)
	page := msg.Page
	pageSize := msg.PageSize
	var pts []pro.ProjectTemplate
	var total int64
	var err error
	//-1全部 0自定义 1系统
	if msg.ViewType == -1 {
		pts, total, err = ps.projectTemplateRepo.FindProjectTemplateAll(ctx, organizationCode, page, pageSize)
	}
	if msg.ViewType == 0 {
		pts, total, err = ps.projectTemplateRepo.FindProjectTemplateCustom(ctx, msg.MemberId, organizationCode, page, pageSize)
	}
	if msg.ViewType == 1 {
		pts, total, err = ps.projectTemplateRepo.FindProjectTemplateSystem(ctx, page, pageSize)
	}
	if err != nil {
		zap.L().Error("FindProjectTemplate error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	//模型转换,获取模板id列表，在步骤模板表中查询
	tsts, err := ps.taskStagesTemplateRepo.FindInProTemIds(ctx, pro.ToProjectTemplateIds(pts))
	if err != nil {
		zap.L().Error("FindProjectTemplate db FindInProTemIds error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	//组装数据
	var ptas []*pro.ProjectTemplateAll
	for _, v := range pts {
		ptas = append(ptas, v.Convert(task.CovertProjectMap(tsts)[v.Id]))
	}

	var pmMsgs []*project.ProjectTemplateMessage
	copier.Copy(&pmMsgs, ptas)
	return &project.ProjectTemplateResponse{Ptm: pmMsgs, Total: total}, nil
}

func (ps *ProjectService) SaveProject(ctx context.Context, msg *project.ProjectRpcMessage) (*project.SaveProjectMessage, error) {
	organizationCodeStr, _ := encrypts.Decrypt(msg.OrganizationCode, model.AESKey)
	organizationCode, _ := strconv.ParseInt(organizationCodeStr, 10, 64)
	templateCodeStr, _ := encrypts.Decrypt(msg.TemplateCode, model.AESKey)
	templateCode, _ := strconv.ParseInt(templateCodeStr, 10, 64)
	//保存项目表
	pr := &pro.Project{
		Name:              msg.Name,
		Description:       msg.Description,
		TemplateCode:      int(templateCode),
		CreateTime:        time.Now().UnixMilli(),
		Cover:             "https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500",
		Deleted:           model.NoDeleted,
		Archive:           model.NoArchive,
		OrganizationCode:  organizationCode,
		AccessControlType: model.Open,
		TaskBoardTheme:    model.Simple,
	}
	err := ps.transaction.Action(func(conn database.DbConn) error {
		err := ps.projectRepo.SaveProject(conn, ctx, pr)
		if err != nil {
			zap.L().Error("SaveProject db SaveProject error", zap.Error(err))
			return errs.GrpcError(model.DBError)
		}
		//保存项目和成员关联表
		pm := &pro.ProjectMember{
			ProjectCode: pr.Id,
			MemberCode:  msg.MemberId,
			JoinTime:    time.Now().UnixMilli(),
			IsOwner:     msg.MemberId,
			Authorize:   "",
		}
		err = ps.projectRepo.SaveProjectMember(conn, ctx, pm)
		if err != nil {
			zap.L().Error("SaveProject db SaveProjectMember error", zap.Error(err))
			return errs.GrpcError(model.DBError)
		}
		return nil
	})
	if err != nil {
		zap.L().Error("SaveProject transaction error", zap.Error(err))
		return nil, err
	}
	code, _ := encrypts.EncryptInt64(pr.Id, model.AESKey)
	rsp := &project.SaveProjectMessage{
		Id:               pr.Id,
		Code:             code,
		OrganizationCode: organizationCodeStr,
		Name:             pr.Name,
		Cover:            pr.Cover,
		CreateTime:       tms.FormatByMill(pr.CreateTime),
		TaskBoardTheme:   pr.TaskBoardTheme,
	}
	//fmt.Println("pr:", pr.Id)
	//fmt.Println("rep:", rsp.Id)
	return rsp, nil
}

func (ps *ProjectService) FindProjectDetail(ctx context.Context, msg *project.ProjectRpcMessage) (*project.ProjectDetailMessage, error) {

	//查收藏表判断收藏状态
	projectCodeStr, _ := encrypts.Decrypt(msg.ProjectCode, model.AESKey)
	projectCode, _ := strconv.ParseInt(projectCodeStr, 10, 64)

	//conn := gorms.GetDB()
	//err := conn.Table("ms_project_member").Select("project_code").Where("id = ?", projectCode).Scan(&projectCode).Error
	//if err != nil {
	//	zap.L().Error("FindProjectDetail get projectCode error", zap.Error(err))
	//	return nil, errs.GrpcError(model.DBError)
	//}

	memberId := msg.MemberId
	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	//查项目和成员的关联表获取项目拥有者 查member表获取名字
	projectAndMember, err := ps.projectRepo.FindProjectByPIdAndMemId(c, projectCode, memberId)
	if err != nil {
		zap.L().Error("FindProjectDetail db FindProjectByPIdAndMemId error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	ownerId := projectAndMember.IsOwner
	member, err := rpc.LoginServiceClient.FindMemInfoById(c, &login.UserMessage{MemId: ownerId})
	if err != nil {
		zap.L().Error("FindProjectDetail rpc FindMemInfoById error", zap.Error(err))
		return nil, err
	}
	//TODO
	isCollect, err := ps.projectRepo.FindCollectByPidAndMemId(c, projectCode, memberId)
	if err != nil {
		zap.L().Error("FindProjectDetail db FindCollectByPidAndMemId error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	if isCollect {
		projectAndMember.Collected = model.Collected
	}
	var detailMsg = &project.ProjectDetailMessage{}
	copier.Copy(detailMsg, projectAndMember)
	detailMsg.OwnerAvatar = member.Avatar
	detailMsg.OwnerName = member.Name
	detailMsg.Code, _ = encrypts.EncryptInt64(projectAndMember.Id, model.AESKey)
	detailMsg.AccessControlType = projectAndMember.GetAccessControlType()
	detailMsg.OrganizationCode, _ = encrypts.EncryptInt64(projectAndMember.OrganizationCode, model.AESKey)
	detailMsg.Order = int32(projectAndMember.Sort)
	detailMsg.CreateTime = tms.FormatByMill(projectAndMember.CreateTime)

	return detailMsg, nil
}

func (ps *ProjectService) UpdateDeletedProject(ctx context.Context, msg *project.ProjectRpcMessage) (*project.DeletedProjectResponse, error) {
	projectCodeStr, _ := encrypts.Decrypt(msg.ProjectCode, model.AESKey)
	projectCode, _ := strconv.ParseInt(projectCodeStr, 10, 64)

	fmt.Println("UpdateDeletedProject projectCode:", projectCode)
	//conn := gorms.GetDB()
	//err := conn.Table("ms_project_member").Select("project_code").Where("id = ?", projectCode).Scan(&projectCode).Error
	//if err != nil {
	//	zap.L().Error("UpdateDeletedProject get projectCode error", zap.Error(err))
	//	return nil, errs.GrpcError(model.DBError)
	//}
	//fmt.Println("projectCode:", projectCode)

	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	err := ps.projectRepo.UpdateDeletedProject(c, projectCode, msg.Deleted)
	if err != nil {
		zap.L().Error("RecycleProject db DeleteProject error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	return &project.DeletedProjectResponse{}, nil
}

func (ps *ProjectService) UpdateProject(ctx context.Context, msg *project.UpdateProjectMessage) (*project.UpdateProjectResponse, error) {
	projectCodeStr, _ := encrypts.Decrypt(msg.ProjectCode, model.AESKey)
	projectCode, _ := strconv.ParseInt(projectCodeStr, 10, 64)
	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	proj := &pro.Project{
		Id:                 projectCode,
		Name:               msg.Name,
		Description:        msg.Description,
		Cover:              msg.Cover,
		TaskBoardTheme:     msg.TaskBoardTheme,
		Prefix:             msg.Prefix,
		Private:            int(msg.Private),
		OpenPrefix:         int(msg.OpenPrefix),
		OpenBeginTime:      int(msg.OpenBeginTime),
		OpenTaskPrivate:    int(msg.OpenTaskPrivate),
		Schedule:           msg.Schedule,
		AutoUpdateSchedule: int(msg.AutoUpdateSchedule),
	}
	err := ps.projectRepo.UpdateProject(c, proj)
	if err != nil {
		zap.L().Error("UpdateProject db UpdateProject error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	return &project.UpdateProjectResponse{}, nil
}
