package interceptor

import (
	"context"
	"encoding/json"
	"go.uber.org/zap"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_project/internal/dao"
	"go_project/ms_project/project_project/internal/repo"
	"google.golang.org/grpc"
	"time"
)

type CacheInterceptor struct {
	cache    repo.Cache
	cacheMap map[string]any
}

func New() *CacheInterceptor {
	cacheMap := make(map[string]any)
	//cacheMap["/project.service.v1.ProjectService/FindProjectByMemId"] = &project.MyProjectResponse{}
	return &CacheInterceptor{
		cache:    dao.Rc,
		cacheMap: cacheMap,
	}
}

func (c *CacheInterceptor) Cache() grpc.ServerOption {
	return grpc.UnaryInterceptor(func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
		//获取当前 gRPC 请求的完整方法名
		respType := c.cacheMap[info.FullMethod]
		if respType == nil {
			return handler(ctx, req)
		}
		//先查询是否有缓存，有缓存直接返回，没有缓存先请求再存入缓存
		con, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()
		marshal, _ := json.Marshal(req)
		cacheKey := encrypts.Md5(string(marshal))
		respJson, err := c.cache.Get(con, info.FullMethod+"::"+cacheKey)
		if respJson != "" {
			json.Unmarshal([]byte(respJson), &respType)
			zap.L().Info(info.FullMethod + " 使用缓存")
			return respType, nil
		}
		resp, err = handler(ctx, req)
		bytes, _ := json.Marshal(resp)
		c.cache.Put(con, info.FullMethod+"::"+cacheKey, string(bytes), 5*time.Minute)
		zap.L().Info(info.FullMethod + " 存入缓存")
		return
	})
}
