package domain

import (
	"context"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/internal/repo"
	"go_project/ms_project/project_project/pkg/model"
)

type MenuDomain struct {
	menuRepo repo.MenuRepo
}

func (d *MenuDomain) MenuTreeList() ([]*data.ProjectMenuChild, *errs.BError) {
	menus, err := d.menuRepo.FindMenus(context.Background())
	if err != nil {
		return nil, model.DBError
	}
	menuChildren := data.CovertChild(menus)
	return menuChildren, nil
}

func NewMenuDomain() *MenuDomain {
	return &MenuDomain{
		menuRepo: dao.NewMenuDao(),
	}
}
