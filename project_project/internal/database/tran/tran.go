package tran

import "go_project/ms_project/project_project/internal/database"

type Transaction interface {
	Action(func(conn database.DbConn) error) error
}
