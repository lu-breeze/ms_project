package repo

import (
	"context"
	"go_project/ms_project/project_project/internal/data/task"
)

type TaskStagesTemplateRepo interface {
	FindInProTemIds(ctx context.Context, ids []int) ([]task.MsTaskStagesTemplate, error)
}
