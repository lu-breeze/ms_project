package dao

import (
	"context"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/internal/database/gorms"
)

type ProjectAuthDao struct {
	conn *gorms.GormConn
}

func (p *ProjectAuthDao) FindAuthList(ctx context.Context, orgCode int64) (list []*data.ProjectAuth, err error) {
	session := p.conn.Session(ctx)
	err = session.Model(&data.ProjectAuth{}).
		Where("organization_code=? and status=1", orgCode).Find(&list).Error
	return
}

func NewProjectAuthDao() *ProjectAuthDao {
	return &ProjectAuthDao{
		conn: gorms.New(),
	}
}
