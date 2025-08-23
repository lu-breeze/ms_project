package department_service_v1

import (
	"context"
	"github.com/jinzhu/copier"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/department"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/database/tran"
	"go_project/ms_project/project_project/internal/domain"
	"go_project/ms_project/project_project/internal/repo"
)

type DepartmentService struct {
	department.UnimplementedDepartmentServiceServer
	cache            repo.Cache
	transaction      tran.Transaction
	departmentDomain *domain.DepartmentDomain
}

func New() *DepartmentService {
	return &DepartmentService{
		cache:            dao.Rc,
		transaction:      dao.NewTransaction(),
		departmentDomain: domain.NewDepartmentDomain(),
	}
}

func (d *DepartmentService) List(ctx context.Context, msg *department.DepartmentReqMessage) (*department.ListDepartmentMessage, error) {
	organizationCode := encrypts.DecryptNoErr(msg.OrganizationCode)
	var parentDepartmentCode int64
	if msg.ParentDepartmentCode != "" {
		parentDepartmentCode = encrypts.DecryptNoErr(msg.ParentDepartmentCode)
	}
	dps, total, err := d.departmentDomain.List(
		organizationCode,
		parentDepartmentCode,
		msg.Page,
		msg.PageSize)
	if err != nil {
		return nil, errs.GrpcError(err)
	}
	var list []*department.DepartmentMessage
	copier.Copy(&list, dps)
	return &department.ListDepartmentMessage{List: list, Total: total}, nil
}
