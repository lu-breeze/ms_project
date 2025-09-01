package repo

import (
	"context"
	"go_project/ms_project/project_project/internal/database"
)

type ProjectAuthNodeRepo interface {
	FindNodeStringList(ctx context.Context, authId int64) ([]string, error)
	DeleteByAuthId(background context.Context, conn database.DbConn, authId int64) error
	Save(background context.Context, conn database.DbConn, authId int64, nodes []string) error
}
