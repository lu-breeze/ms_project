package repo

import (
	"context"
	"go_project/ms_project/project_project/internal/data"
)

type ProjectNodeRepo interface {
	FindAll(ctx context.Context) ([]*data.ProjectNode, error)
}
