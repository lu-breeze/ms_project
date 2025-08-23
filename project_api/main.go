package main

import (
	"fmt"
	"github.com/gin-contrib/pprof"
	"github.com/gin-gonic/gin"
	_ "go_project/ms_project/project_api/api"
	"go_project/ms_project/project_api/api/midd"
	"go_project/ms_project/project_api/config"
	"go_project/ms_project/project_api/router"
	srv "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/encrypts"
	"net/http"
)

func main() {
	fmt.Println(encrypts.DecryptNoErr("e08c"))
	r := gin.Default()
	r.Use(midd.RequestLog())
	r.StaticFS("/upload", http.Dir("upload"))
	//设置路由
	router.InitRouter(r)
	pprof.Register(r)
	srv.Run(r, config.C.SC.Name, config.C.SC.Addr, nil)
}
