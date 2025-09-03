package auth_service_v1

import (
	"context"
	"github.com/jinzhu/copier"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/auth"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/database"
	"go_project/ms_project/project_project/internal/database/tran"
	"go_project/ms_project/project_project/internal/domain"
	"go_project/ms_project/project_project/internal/repo"
)

type AuthService struct {
	auth.UnimplementedAuthServiceServer
	cache                 repo.Cache
	transaction           tran.Transaction
	projectAuthDomain     *domain.ProjectAuthDomain
	projectAuthNodeDomain *domain.ProjectAuthNodeDomain
}

func New() *AuthService {
	return &AuthService{
		cache:                 dao.Rc,
		transaction:           dao.NewTransaction(),
		projectAuthDomain:     domain.NewProjectAuthDomain(),
		projectAuthNodeDomain: domain.NewProjectAuthNodeDomain(),
	}
}

func (a *AuthService) AuthList(ctx context.Context, msg *auth.AuthReqMessage) (*auth.ListAuthMessage, error) {
	organizationCode := encrypts.DecryptNoErr(msg.OrganizationCode)
	listPage, total, err := a.projectAuthDomain.AuthListPage(organizationCode, msg.Page, msg.PageSize)
	if err != nil {
		return nil, errs.GrpcError(err)
	}
	var prList []*auth.ProjectAuth
	copier.Copy(&prList, listPage)
	return &auth.ListAuthMessage{List: prList, Total: total}, nil
}

func (a *AuthService) Apply(ctx context.Context, msg *auth.AuthReqMessage) (*auth.ApplyResponse, error) {
	if msg.Action == "getnode" {
		//获取列表
		list, checkedList, err := a.projectAuthDomain.AllNodeAndAuth(msg.AuthId)
		if err != nil {
			return nil, errs.GrpcError(err)
		}
		var prList []*auth.ProjectNodeMessage
		copier.Copy(&prList, list)
		return &auth.ApplyResponse{List: prList, CheckedList: checkedList}, nil
	}
	if msg.Action == "save" {
		//先删除project_auth_node表 再新增
		nodes := msg.Nodes
		authId := msg.AuthId
		err := a.transaction.Action(func(conn database.DbConn) error {
			err := a.projectAuthNodeDomain.Save(conn, authId, nodes)
			return err
		})
		if err != nil {
			return nil, errs.GrpcError(err.(*errs.BError))
		}
	}
	return &auth.ApplyResponse{}, nil
}

func (a *AuthService) AuthNodesByMemberId(ctx context.Context, msg *auth.AuthReqMessage) (*auth.AuthNodesResponse, error) {
	list, err := a.projectAuthDomain.AuthNodes(msg.MemberId)
	if err != nil {
		return nil, errs.GrpcError(err)
	}
	return &auth.AuthNodesResponse{List: list}, nil
}
