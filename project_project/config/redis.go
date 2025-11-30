package config

import (
	"github.com/redis/go-redis/v9"
	"go_project/ms_project/project_project/internal/dao"
)

func (c *Config) ReConnRedis() {
	rdb := redis.NewClient(c.ReadRedisConfig())
	rc := &dao.RedisCache{
		Rdb: rdb,
	}
	dao.Rc = rc
}
