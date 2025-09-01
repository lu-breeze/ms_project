package domain

import (
	"context"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/database"
	"go_project/ms_project/project_project/internal/repo"
	"go_project/ms_project/project_project/pkg/model"
	"time"
)

type ProjectAuthNodeDomain struct {
	projectAuthNodeRepo repo.ProjectAuthNodeRepo
}

func (d *ProjectAuthNodeDomain) AuthNodeList(authId int64) ([]string, *errs.BError) {
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	list, err := d.projectAuthNodeRepo.FindNodeStringList(ctx, authId)
	if err != nil {
		return nil, model.DBError
	}
	return list, nil
}

func (d *ProjectAuthNodeDomain) Save(conn database.DbConn, authId int64, nodes []string) *errs.BError {
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	err := d.projectAuthNodeRepo.DeleteByAuthId(ctx, conn, authId)
	if err != nil {
		return model.DBError
	}
	if nodes != nil && len(nodes) > 0 {
		err = d.projectAuthNodeRepo.Save(ctx, conn, authId, nodes)
	}
	if err != nil {
		return model.DBError
	}
	return nil
}

func NewProjectAuthNodeDomain() *ProjectAuthNodeDomain {
	return &ProjectAuthNodeDomain{
		projectAuthNodeRepo: dao.NewProjectAuthNodeDao(),
	}
}
