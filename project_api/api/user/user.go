package user

import (
	"context"
	"github.com/gin-gonic/gin"
	"github.com/jinzhu/copier"
	"go_project/ms_project/project_api/api/rpc"
	"go_project/ms_project/project_api/pkg/model/user"
	common "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/errs"
	"go_project/ms_project/project_grpc/user/login"
	"net/http"
	"time"
)

type HandlerUser struct {
}

func New() *HandlerUser {
	return &HandlerUser{}
}

func (*HandlerUser) getCaptcha(ctx *gin.Context) {
	result := &common.Result{}
	mobile := ctx.PostForm("mobile")
	c, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	rsp, err := rpc.LoginServiceClient.GetCaptcha(c, &login.CaptchaMessage{Mobile: mobile})
	if err != nil {
		code, msg := errs.ParseGrpcError(err)
		ctx.JSON(http.StatusOK, result.Fail(code, msg))
		return
	}
	ctx.JSON(http.StatusOK, result.Success(rsp.Code))
}

func (u *HandlerUser) register(c *gin.Context) {
	//获取请求参数
	result := &common.Result{}
	var req user.RegisterReq
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusOK, result.Fail(http.StatusBadRequest, "参数格式错误"))
		return
	}
	//校验参数
	if err := req.Verify(); err != nil {
		c.JSON(http.StatusOK, result.Fail(http.StatusBadRequest, err.Error()))
		return
	}
	//调用grpc中user服务
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	msg := &login.RegisterMessage{}
	if err := copier.Copy(msg, &req); err != nil {
		c.JSON(http.StatusOK, result.Fail(http.StatusBadRequest, "数据转换错误"))
		return
	}
	_, err := rpc.LoginServiceClient.Register(ctx, msg)
	if err != nil {
		code, msg := errs.ParseGrpcError(err)
		c.JSON(http.StatusOK, result.Fail(code, msg))
		return
	}
	//返回结果
	c.JSON(http.StatusOK, result.Success("注册成功"))
}

func (u *HandlerUser) login(c *gin.Context) {
	//获取请求参数
	result := &common.Result{}
	var req user.LoginReq
	if err := c.ShouldBind(&req); err != nil {
		c.JSON(http.StatusOK, result.Fail(http.StatusBadRequest, "参数格式错误"))
		return
	}
	//调用grpc中user登录服务
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()
	msg := &login.LoginMessage{}
	if err := copier.Copy(msg, &req); err != nil {
		c.JSON(http.StatusOK, result.Fail(http.StatusBadRequest, "数据转换错误"))
		return
	}
	loginRsp, err := rpc.LoginServiceClient.Login(ctx, msg)
	if err != nil {
		code, msg := errs.ParseGrpcError(err)
		c.JSON(http.StatusOK, result.Fail(code, msg))
		return
	}
	//返回结果
	rsp := &user.LoginRsp{}
	err = copier.Copy(rsp, loginRsp)
	if err != nil {
		c.JSON(http.StatusOK, result.Fail(http.StatusBadRequest, "数据转换错误"))
		return
	}
	c.JSON(http.StatusOK, result.Success(rsp))
}

func (u *HandlerUser) myOrgList(c *gin.Context) {
	result := &common.Result{}
	memberIdStr, _ := c.Get("memberId")
	memberId := memberIdStr.(int64)
	list, err2 := rpc.LoginServiceClient.MyOrgList(context.Background(), &login.UserMessage{MemId: memberId})
	if err2 != nil {
		code, msg := errs.ParseGrpcError(err2)
		c.JSON(http.StatusOK, result.Fail(code, msg))
		return
	}
	if list.OrganizationList == nil {
		c.JSON(http.StatusOK, result.Success([]*user.OrganizationList{}))
		return
	}
	var orgs []*user.OrganizationList
	copier.Copy(&orgs, list.OrganizationList)
	c.JSON(http.StatusOK, result.Success(orgs))
}
