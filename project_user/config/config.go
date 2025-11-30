package config

import (
	"fmt"
	"go_project/ms_project/project_common/logs"
	"log"
	"os"

	"github.com/redis/go-redis/v9"

	"github.com/spf13/viper"
)

type Config struct {
	viper       *viper.Viper
	SC          *ServerConfig
	GC          *GrpcConfig
	EtcdConfig  *EtcdConfig
	MysqlConfig *MysqlConfig
	JwtConfig   *JwtConfig
}

var C = InitConfig()

type ServerConfig struct {
	Name string
	Addr string
}

type GrpcConfig struct {
	Name    string
	Addr    string
	Version string
	Weight  int64
}

type EtcdConfig struct {
	Addrs []string
}

type MysqlConfig struct {
	Username string
	Password string
	Host     string
	Port     int
	Db       string
}

type JwtConfig struct {
	AccessExp     int
	RefreshExp    int
	AccessSecret  string
	RefreshSecret string
}

func InitConfig() *Config {
	conf := &Config{viper: viper.New()}
	workDir, _ := os.Getwd()
	conf.viper.SetConfigName("config") // 配置文件名
	conf.viper.SetConfigType("yaml")   // 配置文件类型
	conf.viper.AddConfigPath("/etc/ms_project/user")
	conf.viper.AddConfigPath(workDir + "/config") // 配置文件路径
	//conf.viper.AddConfigPath("D:\\go_project\\ms_project\\project_user\\config")
	if err := conf.viper.ReadInConfig(); err != nil {
		log.Fatalln("user读取配置文件失败:", err)
	}
	fmt.Println("user中viper使用的配置文件路径:", conf.viper.ConfigFileUsed())
	fmt.Printf("user中viper config: %#v\n", conf.viper.AllSettings())
	conf.ReadServerConfig()
	conf.ReadGrpcConfig()
	conf.ReadEtcdConfig()
	conf.InitZapLog()
	conf.InitMysqlConfig()
	conf.InitJwtConfig()
	return conf
}

func (c *Config) ReadServerConfig() {
	sc := &ServerConfig{}
	sc.Name = c.viper.GetString("server.name")
	sc.Addr = c.viper.GetString("server.addr")
	c.SC = sc
}

func (c *Config) ReadGrpcConfig() {
	gc := &GrpcConfig{}
	gc.Name = c.viper.GetString("grpc.name")
	gc.Addr = c.viper.GetString("grpc.addr")
	gc.Version = c.viper.GetString("grpc.version")
	gc.Weight = c.viper.GetInt64("grpc.weight")
	c.GC = gc
}

func (c *Config) ReadEtcdConfig() {
	ec := &EtcdConfig{}
	var addrs []string
	if err := c.viper.UnmarshalKey("etcd.addrs", &addrs); err != nil {
		log.Fatalln("读取etcd配置失败:", err)
	}
	ec.Addrs = addrs
	c.EtcdConfig = ec
}

func (c *Config) InitZapLog() {
	lc := &logs.LogConfig{
		DebugFileName: c.viper.GetString("zap.debugFileName"),
		InfoFileName:  c.viper.GetString("zap.infoFileName"),
		WarnFileName:  c.viper.GetString("zap.warnFileName"),
		MaxSize:       c.viper.GetInt("maxSize"),
		MaxAge:        c.viper.GetInt("maxAge"),
		MaxBackups:    c.viper.GetInt("maxBackups"),
	}
	err := logs.InitLogger(lc)
	if err != nil {
		log.Fatalln("初始化日志失败:", err)
	}
}

func (c *Config) ReadRedisConfig() *redis.Options {

	fmt.Println("Redis Addr:", c.viper.GetString("redis.host")+":"+c.viper.GetString("redis.port"))
	return &redis.Options{
		Addr:     c.viper.GetString("redis.host") + ":" + c.viper.GetString("redis.port"),
		Password: c.viper.GetString("redis.password"),
		DB:       c.viper.GetInt("redis.db"),
	}
}

func (c *Config) InitMysqlConfig() {
	mc := &MysqlConfig{
		Username: c.viper.GetString("mysql.username"),
		Password: c.viper.GetString("mysql.password"),
		Host:     c.viper.GetString("mysql.host"),
		Port:     c.viper.GetInt("mysql.port"),
		Db:       c.viper.GetString("mysql.db"),
	}
	c.MysqlConfig = mc
}

func (c *Config) InitJwtConfig() {
	jwt := &JwtConfig{
		AccessExp:     c.viper.GetInt("jwt.accessExp"),
		RefreshExp:    c.viper.GetInt("jwt.refreshExp"),
		AccessSecret:  c.viper.GetString("jwt.accessSecret"),
		RefreshSecret: c.viper.GetString("jwt.refreshSecret"),
	}
	c.JwtConfig = jwt
}
