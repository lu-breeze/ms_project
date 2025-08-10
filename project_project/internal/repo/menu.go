package repo

import (
	"context"
	"go_project/ms_project/project_project/internal/data/menu"
)

type MenuRepo interface {
	FindMenus(ctx context.Context) ([]*menu.ProjectMenu, error)
}
