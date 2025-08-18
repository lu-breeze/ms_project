package project_service_v1

import (
	"context"
	"go.uber.org/zap"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/project"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/pkg/model"
	"strconv"
	"time"
)

func (ps *ProjectService) UpdateCollectProject(ctx context.Context, msg *project.ProjectRpcMessage) (*project.CollectProjectResponse, error) {
	projectCodeStr, _ := encrypts.Decrypt(msg.ProjectCode, model.AESKey)
	projectCode, _ := strconv.ParseInt(projectCodeStr, 10, 64)

	//conn := gorms.GetDB()
	//err := conn.Table("ms_project_member").Select("project_code").Where("id = ?", projectCode).Scan(&projectCode).Error
	//if err != nil {
	//	zap.L().Error("UpdateCollectProject get projectCode error", zap.Error(err))
	//	return nil, errs.GrpcError(model.DBError)
	//}

	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	var err error
	if "collect" == msg.CollectType {
		pc := &data.ProjectCollection{
			ProjectCode: projectCode,
			MemberCode:  msg.MemberId,
			CreateTime:  time.Now().UnixMilli(),
		}
		err = ps.projectRepo.SaveProjectCollect(c, pc)
	}
	if "cancel" == msg.CollectType {
		err = ps.projectRepo.DeleteProjectCollect(c, msg.MemberId, projectCode)
	}

	if err != nil {
		zap.L().Error("UpdateCollectProject db error", zap.Error(err))
		return nil, errs.GrpcError(model.DBError)
	}
	return &project.CollectProjectResponse{}, nil
}
