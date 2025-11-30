package interceptor

import (
	"context"
	"encoding/json"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_grpc/user/login"
	"go_project/ms_project/project_user/internal/dao"
	"go_project/ms_project/project_user/internal/repo"
	"reflect"
	"time"

	"go.uber.org/zap"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/proto"
)

type CacheInterceptor struct {
	cache    repo.Cache
	cacheMap map[string]reflect.Type
}

func New() *CacheInterceptor {
	cacheMap := make(map[string]reflect.Type)
	cacheMap["/login.service.v1.LoginService/MyOrgList"] = reflect.TypeOf(&login.OrgListResponse{})
	cacheMap["/login.service.v1.LoginService/FindMemInfoById"] = reflect.TypeOf(&login.MemberMessage{})
	return &CacheInterceptor{cache: dao.Rc, cacheMap: cacheMap}
}

var CacheClient = New()

func (c *CacheInterceptor) Cache() grpc.ServerOption {
	return grpc.UnaryInterceptor(func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
		respType, ok := c.cacheMap[info.FullMethod]
		if !ok || respType == nil {
			return handler(ctx, req)
		}

		con, cancel := context.WithTimeout(ctx, 2*time.Second)
		defer cancel()

		// 构造缓存 key，优先使用 proto 序列化请求
		var keyData []byte
		if pm, ok := req.(proto.Message); ok {
			if b, e := proto.Marshal(pm); e == nil {
				keyData = b
			} else {
				zap.L().Warn("proto marshal request failed", zap.Error(e))
				if jb, je := json.Marshal(req); je == nil {
					keyData = jb
				}
			}
		} else {
			if jb, je := json.Marshal(req); je == nil {
				keyData = jb
			}
		}
		cacheKey := encrypts.Md5(string(keyData))

		// 尝试从缓存读取
		respJson, getErr := c.cache.Get(con, info.FullMethod+"::"+cacheKey)
		if getErr == nil && respJson != "" {
			newInst := reflect.New(respType.Elem()).Interface()
			if pm, ok := newInst.(proto.Message); ok {
				if perr := proto.Unmarshal([]byte(respJson), pm); perr == nil {
					zap.L().Info(info.FullMethod + " 走了缓存")
					return newInst, nil
				} else {
					zap.L().Warn("proto unmarshal cache failed", zap.Error(perr))
				}
			} else {
				if jerr := json.Unmarshal([]byte(respJson), newInst); jerr == nil {
					zap.L().Info(info.FullMethod + " 走了缓存")
					return newInst, nil
				} else {
					zap.L().Warn("json unmarshal cache failed", zap.Error(jerr))
				}
			}
		} else if getErr != nil {
			zap.L().Warn("cache get failed", zap.String("method", info.FullMethod), zap.Error(getErr))
		}

		// 缓存未命中或反序列化失败，调用真实 handler
		resp, err = handler(ctx, req)
		if err != nil {
			return resp, err
		}

		// 序列化响应并写入缓存（只在成功且能序列化时）
		var valBytes []byte
		if pm, ok := resp.(proto.Message); ok {
			if b, merr := proto.Marshal(pm); merr == nil {
				valBytes = b
			} else {
				zap.L().Warn("proto marshal response failed", zap.Error(merr))
			}
		} else {
			if b, merr := json.Marshal(resp); merr == nil {
				valBytes = b
			} else {
				zap.L().Warn("json marshal response failed", zap.Error(merr))
			}
		}

		if len(valBytes) > 0 {
			if perr := c.cache.Put(con, info.FullMethod+"::"+cacheKey, string(valBytes), 5*time.Minute); perr != nil {
				zap.L().Warn("cache put failed", zap.String("method", info.FullMethod), zap.Error(perr))
			} else {
				zap.L().Info(info.FullMethod + " 放入缓存")
			}
		}

		return resp, nil
	})
}

func (c *CacheInterceptor) CacheInterceptor() func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
	return func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp interface{}, err error) {
		respType, ok := c.cacheMap[info.FullMethod]
		if !ok || respType == nil {
			return handler(ctx, req)
		}

		con, cancel := context.WithTimeout(ctx, 2*time.Second)
		defer cancel()

		// 构造缓存 key，优先使用 proto 序列化请求
		var keyData []byte
		if pm, ok := req.(proto.Message); ok {
			if b, e := proto.Marshal(pm); e == nil {
				keyData = b
			} else {
				zap.L().Warn("proto marshal request failed", zap.Error(e))
				if jb, je := json.Marshal(req); je == nil {
					keyData = jb
				}
			}
		} else {
			if jb, je := json.Marshal(req); je == nil {
				keyData = jb
			}
		}
		cacheKey := encrypts.Md5(string(keyData))

		// 尝试从缓存读取
		respJson, getErr := c.cache.Get(con, info.FullMethod+"::"+cacheKey)
		if getErr == nil && respJson != "" {
			newInst := reflect.New(respType.Elem()).Interface()
			if pm, ok := newInst.(proto.Message); ok {
				if perr := proto.Unmarshal([]byte(respJson), pm); perr == nil {
					zap.L().Info(info.FullMethod + " 走了缓存")
					return newInst, nil
				} else {
					zap.L().Warn("proto unmarshal cache failed", zap.Error(perr))
				}
			} else {
				if jerr := json.Unmarshal([]byte(respJson), newInst); jerr == nil {
					zap.L().Info(info.FullMethod + " 走了缓存")
					return newInst, nil
				} else {
					zap.L().Warn("json unmarshal cache failed", zap.Error(jerr))
				}
			}
		} else if getErr != nil {
			zap.L().Warn("cache get failed", zap.String("method", info.FullMethod), zap.Error(getErr))
		}

		// 缓存未命中或反序列化失败，调用真实 handler
		resp, err = handler(ctx, req)
		if err != nil {
			return resp, err
		}

		// 序列化响应并写入缓存（只在成功且能序列化时）
		var valBytes []byte
		if pm, ok := resp.(proto.Message); ok {
			if b, merr := proto.Marshal(pm); merr == nil {
				valBytes = b
			} else {
				zap.L().Warn("proto marshal response failed", zap.Error(merr))
			}
		} else {
			if b, merr := json.Marshal(resp); merr == nil {
				valBytes = b
			} else {
				zap.L().Warn("json marshal response failed", zap.Error(merr))
			}
		}

		if len(valBytes) > 0 {
			if perr := c.cache.Put(con, info.FullMethod+"::"+cacheKey, string(valBytes), 5*time.Minute); perr != nil {
				zap.L().Warn("cache put failed", zap.String("method", info.FullMethod), zap.Error(perr))
			} else {
				zap.L().Info(info.FullMethod + " 放入缓存")
			}
		}

		return resp, nil
	}
}
