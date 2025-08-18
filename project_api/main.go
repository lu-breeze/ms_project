package main

import (
	"github.com/gin-gonic/gin"
	_ "go_project/ms_project/project_api/api"
	"go_project/ms_project/project_api/api/midd"
	"go_project/ms_project/project_api/config"
	"go_project/ms_project/project_api/router"
	srv "go_project/ms_project/project_common"
	"net/http"
)

func main() {
	//fmt.Println(encrypts.DecryptNoErr("e08ff4b1"))
	r := gin.Default()
	r.Use(midd.RequestLog())
	r.StaticFS("/upload", http.Dir("upload"))
	//设置路由
	router.InitRouter(r)
	srv.Run(r, config.C.SC.Name, config.C.SC.Addr, nil)
}
