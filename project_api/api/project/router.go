package project

import (
	"github.com/gin-gonic/gin"
	"go_project/ms_project/project_api/api/midd"
	"go_project/ms_project/project_api/router"
	"log"
)

type RouterProject struct {
}

func init() {
	log.Println("init user router")
	ru := &RouterProject{}
	router.Register(ru)
}

func (*RouterProject) Route(r *gin.Engine) {
	//初始化grpc客户端连接
	InitRpcProjectClient()
	h := New()
	group := r.Group("/project/index")
	group.Use(midd.ToKenVerify())
	group.POST("", h.Index)
}
