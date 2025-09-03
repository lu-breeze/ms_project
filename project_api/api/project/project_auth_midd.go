package project

import (
	"github.com/gin-gonic/gin"
	common "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/errs"
	"net/http"
)

func ProjectAuth() func(*gin.Context) {
	return func(c *gin.Context) {
		result := &common.Result{}
		//如果当前用户不是这个项目的成员，无权限查看项目和操作项目
		//判断是否需要项目认证
		isProjectAuth := false
		projectCode := c.PostForm("projectCode")
		if projectCode != "" {
			isProjectAuth = true
		}
		taskCode := c.PostForm("taskCode")
		if taskCode != "" {
			isProjectAuth = true
		}
		if isProjectAuth {
			memberId := c.GetInt64("memberId")
			p := New()
			pr, isMember, isOwner, err := p.FindProjectByMemberId(memberId, projectCode, taskCode)
			if err != nil {
				code, msg := errs.ParseGrpcError(err)
				c.JSON(http.StatusOK, result.Fail(code, msg))
				c.Abort()
				return
			}
			if !isMember {
				c.JSON(http.StatusOK, result.Fail(403, "不是项目成员，无操作权限"))
				c.Abort()
				return
			}
			if pr.Private == 1 {
				//私有项目
				if isOwner || isMember {
					c.Next()
					return
				} else {
					c.JSON(http.StatusOK, result.Fail(403, "私有项目，无操作权限"))
					c.Abort()
					return
				}
			}
		}
	}
}
