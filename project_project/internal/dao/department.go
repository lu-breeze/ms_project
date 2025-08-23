package dao

import (
	"context"
	"go_project/ms_project/project_project/internal/data"
	"go_project/ms_project/project_project/internal/database/gorms"
)

type DepartmentDao struct {
	conn *gorms.GormConn
}

func (d *DepartmentDao) FindDepartment(ctx context.Context, organizationCode int64, parentDepartmentCode int64, name string) (*data.Department, error) {
	//TODO implement me
	panic("implement me")
}

func (d *DepartmentDao) Save(dpm *data.Department) error {
	//TODO implement me
	panic("implement me")
}

func (d *DepartmentDao) ListDepartment(organizationCode int64, parentDepartmentCode int64, page int64, size int64) (list []*data.Department, total int64, err error) {
	session := d.conn.Session(context.Background())
	query := session.Model(&data.Department{})
	query = query.Where("organization_code=?", organizationCode)
	if parentDepartmentCode > 0 {
		query = query.Where("pcode=?", parentDepartmentCode)
	}
	err = query.Count(&total).Error

	err = query.Limit(int(size)).Offset(int((page - 1) * size)).Find(&list).Error
	return
}

func (d *DepartmentDao) FindDepartmentById(ctx context.Context, id int64) (dt *data.Department, err error) {
	session := d.conn.Session(ctx)
	err = session.Where("id=?", id).Find(&dt).Error
	return
}

func NewDepartmentDao() *DepartmentDao {
	return &DepartmentDao{
		conn: gorms.New(),
	}
}
