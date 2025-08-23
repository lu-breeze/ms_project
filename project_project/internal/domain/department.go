package domain

import (
	"context"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/internal/repo"
	"go_project/ms_project/project_project/pkg/model"
	"time"
)

type DepartmentDomain struct {
	departmentRepo repo.DepartmentRepo
}

func (d *DepartmentDomain) FindDepartmentById(id int64) (*data.Department, error) {
	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	return d.departmentRepo.FindDepartmentById(c, id)
}

func (d *DepartmentDomain) List(organizationCode int64, parentDepartmentCode int64, page int64, size int64) ([]*data.DepartmentDisplay, int64, *errs.BError) {
	list, total, err := d.departmentRepo.ListDepartment(organizationCode, parentDepartmentCode, page, size)
	if err != nil {
		return nil, 0, model.DBError
	}
	var dList []*data.DepartmentDisplay
	for _, v := range list {
		dList = append(dList, v.ToDisplay())
	}
	return dList, total, nil
}

func NewDepartmentDomain() *DepartmentDomain {
	return &DepartmentDomain{
		departmentRepo: dao.NewDepartmentDao(),
	}
}
