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
	projectAuthRepo       repo.ProjectAuthRepo
	UserRpcDomain         *UserRpcDomain
	projectNodeDomain     *ProjectNodeDomain
	ProjectAuthNodeDomain *ProjectAuthNodeDomain
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

func (d *ProjectAuthDomain) AuthListPage(orgCode int64, page int64, pageSize int64) ([]*data.ProjectAuthDisplay, int64, *errs.BError) {
	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	list, total, err := d.projectAuthRepo.FindAuthListPage(c, orgCode, page, pageSize)
	if err != nil {
		zap.L().Error("project AuthList projectAuthRepo.FindAuthList error", zap.Error(err))
		return nil, 0, model.DBError
	}
	var pdList []*data.ProjectAuthDisplay
	for _, v := range list {
		display := v.ToDisplay()
		pdList = append(pdList, display)
	}
	return pdList, total, nil
}

func (d *ProjectAuthDomain) AllNodeAndAuth(authId int64) ([]*data.ProjectNodeAuthTree, []string, *errs.BError) {
	treeList, err := d.projectNodeDomain.NodeList()
	if err != nil {
		return nil, nil, err
	}
	checkedList, err := d.ProjectAuthNodeDomain.AuthNodeList(authId)
	if err != nil {
		return nil, nil, err
	}
	list := data.ToAuthNodeTreeList(treeList, checkedList)
	return list, checkedList, nil
}

//func (d *ProjectAuthDomain) Save(conn database.DbConn, authId int64, nodes []string) *errs.BError {
//	err := d.ProjectAuthNodeDomain.Save(context.Background(), conn, authId, nodes)
//	if err != nil {
//		return err
//	}
//	return nil
//}

func NewProjectAuthDomain() *ProjectAuthDomain {
	return &ProjectAuthDomain{
		projectAuthRepo:       dao.NewProjectAuthDao(),
		UserRpcDomain:         NewUserRpcDomain(),
		projectNodeDomain:     NewProjectNodeDomain(),
		ProjectAuthNodeDomain: NewProjectAuthNodeDomain(),
	}
}
