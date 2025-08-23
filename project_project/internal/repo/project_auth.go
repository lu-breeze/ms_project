package repo

import (
	"context"
	"go_project/ms_project/project_project/internal/data"
)

type ProjectAuthRepo interface {
	FindAuthList(ctx context.Context, orgCode int64) (list []*data.ProjectAuth, err error)
}
