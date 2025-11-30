package config

import (
	"bytes"
	"fmt"
	"github.com/nacos-group/nacos-sdk-go/v2/vo"
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
	DbConfig    DbConfig
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
	Name     string
}

type DbConfig struct {
	Master     MysqlConfig
	Slave      []MysqlConfig
	Separation bool
}

type JwtConfig struct {
	AccessExp     int
	RefreshExp    int
	AccessSecret  string
	RefreshSecret string
}

func InitConfig() *Config {
	conf := &Config{viper: viper.New()}
	//先从nacos读取配置
	nacosClient := InitNacosClient()
	configYaml, err2 := nacosClient.confClient.GetConfig(vo.ConfigParam{
		DataId: "config.yaml",
		Group:  nacosClient.group,
	})
	if err2 != nil {
		log.Fatalln("从nacos读取配置失败:", err2)
	}
	err2 = nacosClient.confClient.ListenConfig(vo.ConfigParam{
		DataId: "config.yaml",
		Group:  nacosClient.group,
		OnChange: func(namespace, group, dataId, data string) {
			log.Printf("配置文件变更, namespace: %s, group: %s, dataId: %s, data: %s", namespace, group, dataId, data)
			err := conf.viper.ReadConfig(bytes.NewBuffer([]byte(data)))
			if err != nil {
				log.Printf("配置文件变更后读取配置失败: %v", err)
			}
			conf.ReLoadAllConfig()
		},
	})
	if err2 != nil {
		log.Fatalln("监听nacos配置失败:", err2)
	}
	conf.viper.SetConfigType("yaml")
	if configYaml != "" {
		err := conf.viper.ReadConfig(bytes.NewBuffer([]byte(configYaml)))
		if err != nil {
			log.Fatalln(err)
		}
		//log.Printf("project从nacos读取配置: %s\n", configYaml)
	} else {
		workDir, _ := os.Getwd()
		conf.viper.SetConfigName("config") // 配置文件名
		conf.viper.SetConfigType("yaml")   // 配置文件类型
		conf.viper.AddConfigPath("/etc/ms_project/user")
		conf.viper.AddConfigPath(workDir + "/config") // 配置文件路径
		if err := conf.viper.ReadInConfig(); err != nil {

			log.Fatalln("user读取配置文件失败:", err)
		}
		fmt.Println("project中viper使用的配置文件路径:", conf.viper.ConfigFileUsed())
		fmt.Printf("project中viper config: %#v\n", conf.viper.AllSettings())
	}
	conf.ReLoadAllConfig()
	return conf
}

func (c *Config) ReLoadAllConfig() {
	c.ReadServerConfig()
	c.InitZapLog()
	c.ReadGrpcConfig()
	c.ReadEtcdConfig()
	c.InitMysqlConfig()
	c.InitJwtConfig()
	c.InitDbConfig()
	//重新创建相关的客户端
	c.ReConnRedis()
	c.ReConnMysql()
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

func (c *Config) InitDbConfig() {
	mc := DbConfig{}
	mc.Separation = c.viper.GetBool("db.separation")
	var slaves []MysqlConfig
	err := c.viper.UnmarshalKey("db.slave", &slaves)
	if err != nil {
		panic(err)
	}
	master := MysqlConfig{
		Username: c.viper.GetString("db.master.username"),
		Password: c.viper.GetString("db.master.password"),
		Host:     c.viper.GetString("db.master.host"),
		Port:     c.viper.GetInt("db.master.port"),
		Db:       c.viper.GetString("db.master.db"),
	}
	mc.Master = master
	mc.Slave = slaves
	c.DbConfig = mc
}
