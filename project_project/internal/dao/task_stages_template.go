package dao

import (
	"context"
	"go_project/ms_project/project_project/internal/data/task"
	"go_project/ms_project/project_project/internal/database/gorms"
)

type TaskStagesTemplateDao struct {
	conn *gorms.GormConn
}

func (t *TaskStagesTemplateDao) FindInProTemIds(ctx context.Context, ids []int) ([]task.MsTaskStagesTemplate, error) {
	var tsts []task.MsTaskStagesTemplate
	session := t.conn.Session(ctx)
	err := session.Where("project_template_code in ?", ids).Find(&tsts).Error
	return tsts, err
}

func NewTaskStagesTemplateDao() *TaskStagesTemplateDao {
	return &TaskStagesTemplateDao{
		conn: gorms.New(),
	}
}
