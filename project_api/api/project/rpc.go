package project

import (
	"go_project/ms_project/project_api/config"
	"go_project/ms_project/project_common/discovery"
	"go_project/ms_project/project_common/logs"
	"go_project/ms_project/project_grpc/project"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/resolver"
	"log"
)

var ProjectServiceClient project.ProjectServiceClient

func InitRpcProjectClient() {
	etcdRegister := discovery.NewResolver(config.C.EtcdConfig.Addrs, logs.LG)
	resolver.Register(etcdRegister)

	conn, err := grpc.Dial("etcd:///project", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatalf("failed to connect: %v", err)
	}
	ProjectServiceClient = project.NewProjectServiceClient(conn)
}
