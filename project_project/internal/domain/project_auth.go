package domain

import (
	"context"
	"go.uber.org/zap"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/internal/repo"
	"go_project/ms_project/project_project/pkg/model"
	"time"
)

type ProjectAuthDomain struct {
	projectAuthRepo repo.ProjectAuthRepo
	UserRpcDomain   *UserRpcDomain
}

func (d *ProjectAuthDomain) AuthList(orgCode int64) ([]*data.ProjectAuthDisplay, *errs.BError) {
	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	list, err := d.projectAuthRepo.FindAuthList(c, orgCode)
	if err != nil {
		zap.L().Error("project AuthList projectAuthRepo.FindAuthList error", zap.Error(err))
		return nil, model.DBError
	}
	var pdList []*data.ProjectAuthDisplay
	for _, v := range list {
		display := v.ToDisplay()
		pdList = append(pdList, display)
	}
	return pdList, nil
}

func NewProjectAuthDomain() *ProjectAuthDomain {
	return &ProjectAuthDomain{
		projectAuthRepo: dao.NewProjectAuthDao(),
		UserRpcDomain:   NewUserRpcDomain(),
	}
}
