package repo

import (
	"context"
	"go_project/ms_project/project_project/internal/data"
)

type AccountRepo interface {
	FindList(ctx context.Context, condition string, organizationCode int64, departmentCode int64, page int64, pageSize int64) ([]*data.MemberAccount, int64, error)
}
