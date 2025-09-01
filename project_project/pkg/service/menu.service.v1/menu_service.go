package menu_service_v1

import (
	"context"
	"github.com/jinzhu/copier"
	"go.uber.org/zap"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/menu"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/database/tran"
	"go_project/ms_project/project_project/internal/domain"
	"go_project/ms_project/project_project/internal/repo"
)

type MenuService struct {
	menu.UnimplementedMenuServiceServer
	cache       repo.Cache
	transaction tran.Transaction
	menuDomain  *domain.MenuDomain
}

func New() *MenuService {
	return &MenuService{
		cache:       dao.Rc,
		transaction: dao.NewTransaction(),
		menuDomain:  domain.NewMenuDomain(),
	}
}

func (m *MenuService) MenuList(context.Context, *menu.MenuReqMessage) (*menu.MenuResponseMessage, error) {
	treeList, err := m.menuDomain.MenuTreeList()
	if err != nil {
		zap.L().Error("MenuList error", zap.Error(err))
		return nil, errs.GrpcError(err)
	}
	var list []*menu.MenuMessage
	copier.Copy(&list, treeList)
	return &menu.MenuResponseMessage{List: list}, nil
}
