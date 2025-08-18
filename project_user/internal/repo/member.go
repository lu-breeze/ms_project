package repo

import (
	"context"
	"go_project/ms_project/project_user/internal/data/member"
	"go_project/ms_project/project_user/internal/database"
)

type MemberRepo interface {
	GetMemberByEmail(ctx context.Context, email string) (bool, error)
	GetMemberByAccount(ctx context.Context, account string) (bool, error)
	GetMemberByMobile(ctx context.Context, mobile string) (bool, error)
	SaveMember(conn database.DbConn, ctx context.Context, mem *member.Member) error
	FindMember(ctx context.Context, account string, pwd string) (*member.Member, error)
	FindMemberById(ctx context.Context, id int64) (*member.Member, error)
	FindMemberByIds(background context.Context, ids []int64) (list []*member.Member, err error)
}
