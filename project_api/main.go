package main

import (
	"fmt"
	"github.com/gin-contrib/pprof"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/propagation"
	_ "go_project/ms_project/project_api/api"
	"go_project/ms_project/project_api/api/midd"
	"go_project/ms_project/project_api/config"
	"go_project/ms_project/project_api/router"
	"go_project/ms_project/project_api/tracing"
	srv "go_project/ms_project/project_common"
	"go_project/ms_project/project_common/encrypts"
	"log"
	"net/http"
)

func main() {
	fmt.Println(encrypts.DecryptNoErr("e08c"))
	r := gin.Default()

	tp, tpErr := tracing.JaegerTraceProvider()
	if tpErr != nil {
		log.Fatal(tpErr)
	}
	otel.SetTracerProvider(tp)
	//把全局的文本型上下文传播器设置为一个组合传播器
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))
	r.Use(midd.RequestLog())
	r.Use(otelgin.Middleware("project_api"))

	r.StaticFS("/upload", http.Dir("upload"))
	//设置路由
	router.InitRouter(r)
	pprof.Register(r)
	srv.Run(r, config.C.SC.Name, config.C.SC.Addr, nil)
}
