package main

import (
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/propagation"
	srv "go_project/ms_project/project_common"
	"go_project/ms_project/project_project/config"
	"go_project/ms_project/project_project/router"
	"go_project/ms_project/project_project/tracing"
	"log"
)

func main() {
	r := gin.Default()
	tp, tpErr := tracing.JaegerTraceProvider()
	if tpErr != nil {
		log.Fatal(tpErr)
	}
	otel.SetTracerProvider(tp)
	//把全局的文本型上下文传播器设置为一个组合传播器
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(propagation.TraceContext{}, propagation.Baggage{}))

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
