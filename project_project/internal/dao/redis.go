package dao

import (
	"context"
	"github.com/redis/go-redis/v9"
	"time"
)

type RedisCache struct {
	Rdb *redis.Client
}

var Rc *RedisCache

/*
	func init() {
		Rdb := redis.NewClient(config.C.ReadRedisConfig())
		//pong, err := Rdb.Ping(context.Background()).Result()
		//if err != nil {
		//	log.Fatal("redis连接失败：", err)
		//}
		//fmt.Println("redis成功连接:", pong) // 应输出 PONG

		Rc = &RedisCache{
			Rdb: Rdb,
		}
	}
*/
func (rc *RedisCache) Put(ctx context.Context, key, value string, expire time.Duration) error {
	err := rc.Rdb.Set(ctx, key, value, expire).Err()
	return err
}

func (rc *RedisCache) Get(ctx context.Context, key string) (string, error) {
	result, err := rc.Rdb.Get(ctx, key).Result()
	return result, err
}
