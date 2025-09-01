package dao

import (
	"context"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/internal/database/gorms"
)

type ProjectNodeDao struct {
	conn *gorms.GormConn
}

func (m *ProjectNodeDao) FindAll(ctx context.Context) (pms []*data.ProjectNode, err error) {
	session := m.conn.Session(ctx)
	err = session.Model(&data.ProjectNode{}).Find(&pms).Error
	return
}

func NewProjectNodeDao() *ProjectNodeDao {
	return &ProjectNodeDao{
		conn: gorms.New(),
	}
}
