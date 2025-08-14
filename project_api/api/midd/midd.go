package midd

import (
	"context"
	"github.com/gin-gonic/gin"
	"go_project/ms_project/project_api/api/rpc"
	common "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/user/login"
	"net/http"
	"time"
)

func ToKenVerify() func(ctx *gin.Context) {
	return func(c *gin.Context) {
		result := &common.Result{}
		//从header中获取token
		token := c.GetHeader("Authorization")
		//调用user服务认证token
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()
		response, err := rpc.LoginServiceClient.TokenVerify(ctx, &login.LoginMessage{Token: token})
		if err != nil {
			code, msg := errs.ParseGrpcError(err)
			c.JSON(http.StatusOK, result.Fail(code, msg))
			c.Abort()
		}

		c.Set("memberId", response.Member.Id)
		c.Set("memberName", response.Member.Name)
		c.Set("organizationCode", response.Member.OrganizationCode)
		c.Next()
	}
}
