package project

import (
	"context"
	"github.com/gin-gonic/gin"
	common "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/project"
	"net/http"
	"time"
)

type HandlerProject struct {
}

func (p *HandlerProject) Index(c *gin.Context) {
	result := &common.Result{}
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	msg := &project.IndexMessage{}
	indexResponse, err := ProjectServiceClient.Index(ctx, msg)
	if err != nil {
		code, msg := errs.ParseGrpcError(err)
		c.JSON(http.StatusOK, result.Fail(code, msg))
	}
	c.JSON(http.StatusOK, result.Success(indexResponse.Menus))
}

func New() *HandlerProject {
	return &HandlerProject{}
}
