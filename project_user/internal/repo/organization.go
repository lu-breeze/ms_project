package repo

import (
	"context"
	"go_project/ms_project/project_user/internal/data/organization"
	"go_project/ms_project/project_user/internal/database"
)

type OrganizationRepo interface {
	SaveOrganization(conn database.DbConn, ctx context.Context, org *organization.Organization) error
	FindOrganizationByMemId(ctx context.Context, memId int64) ([]*organization.Organization, error)
}
