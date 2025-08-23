package main

import (
	"github.com/gin-gonic/gin"
	srv "go_project/ms_project/project_common"
	"go_project/ms_project/project_project/config"
	"go_project/ms_project/project_project/router"
)

func main() {
	r := gin.Default()
	//设置路由
	router.InitRouter(r)
	//初始化rpc调用
	router.InitUserRpc()
	//grpc服务注册
	gc := router.RegisterGrpc()
	router.RegisterEtcdServer()
	stop := func() {
		gc.Stop()
	}

	srv.Run(r, config.C.SC.Name, config.C.SC.Addr, stop)
}
