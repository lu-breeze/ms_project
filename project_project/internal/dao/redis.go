package dao

import (
	"context"
	"github.com/redis/go-redis/v9"
	"go_project/ms_project/project_user/config"
	"time"
)

type RedisCache struct {
	rdb *redis.Client
}

var Rc *RedisCache

func init() {
	rdb := redis.NewClient(config.C.ReadRedisConfig())
	//pong, err := rdb.Ping(context.Background()).Result()
	//if err != nil {
	//	log.Fatal("redis连接失败：", err)
	//}
	//fmt.Println("redis成功连接:", pong) // 应输出 PONG

	Rc = &RedisCache{
		rdb: rdb,
	}
}

func (rc *RedisCache) Put(ctx context.Context, key, value string, expire time.Duration) error {
	err := rc.rdb.Set(ctx, key, value, expire).Err()
	return err
}

func (rc *RedisCache) Get(ctx context.Context, key string) (string, error) {
	result, err := rc.rdb.Get(ctx, key).Result()
	return result, err
}
