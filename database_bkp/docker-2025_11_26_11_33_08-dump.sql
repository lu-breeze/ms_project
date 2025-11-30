use msproject_slave1;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: msproject
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ms_department`
--

DROP TABLE IF EXISTS `ms_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_department` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `organization_code` bigint DEFAULT NULL COMMENT '组织编号',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `sort` int DEFAULT '0' COMMENT '排序',
  `pcode` bigint DEFAULT NULL COMMENT '上级编号',
  `icon` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '上级路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_department`
--

LOCK TABLES `ms_department` WRITE;
/*!40000 ALTER TABLE `ms_department` DISABLE KEYS */;
INSERT INTO `ms_department` (`id`, `organization_code`, `name`, `sort`, `pcode`, `icon`, `create_time`, `path`) VALUES (5,14,'部门1',0,NULL,NULL,NULL,NULL),(6,14,'部门2',0,0,NULL,1756605483280,'');
/*!40000 ALTER TABLE `ms_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_department_member`
--

DROP TABLE IF EXISTS `ms_department_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_department_member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `department_code` bigint DEFAULT NULL COMMENT '部门id',
  `organization_code` bigint DEFAULT NULL COMMENT '组织id',
  `account_code` bigint DEFAULT NULL COMMENT '成员id',
  `join_time` bigint DEFAULT NULL COMMENT '加入时间',
  `is_principal` tinyint(1) DEFAULT NULL COMMENT '是否负责人',
  `is_owner` tinyint(1) DEFAULT '0' COMMENT '拥有者',
  `authorize` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '角色',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='部门-成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_department_member`
--

LOCK TABLES `ms_department_member` WRITE;
/*!40000 ALTER TABLE `ms_department_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `ms_department_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_file`
--

DROP TABLE IF EXISTS `ms_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_file` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `path_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '相对路径',
  `title` char(90) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '名称',
  `extension` char(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '扩展名',
  `size` int unsigned DEFAULT '0' COMMENT '文件大小',
  `object_type` char(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '对象类型',
  `organization_code` bigint DEFAULT NULL COMMENT '组织编码',
  `task_code` bigint DEFAULT NULL COMMENT '任务编码',
  `project_code` bigint DEFAULT NULL COMMENT '项目编码',
  `create_by` bigint DEFAULT NULL COMMENT '上传人',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `downloads` mediumint unsigned DEFAULT '0' COMMENT '下载次数',
  `extra` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '额外信息',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '删除标记',
  `file_url` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '完整地址',
  `file_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '文件类型',
  `deleted_time` bigint DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='文件表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_file`
--

LOCK TABLES `ms_file` WRITE;
/*!40000 ALTER TABLE `ms_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `ms_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_member`
--

DROP TABLE IF EXISTS `ms_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '系统前台用户表',
  `account` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户登陆账号',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '登陆密码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '用户昵称',
  `mobile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机',
  `realname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实姓名',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态',
  `last_login_time` bigint DEFAULT NULL COMMENT '上次登录时间',
  `sex` tinyint DEFAULT '0' COMMENT '性别',
  `avatar` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '头像',
  `idcard` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '身份证',
  `province` int DEFAULT '0' COMMENT '省',
  `city` int DEFAULT '0' COMMENT '市',
  `area` int DEFAULT '0' COMMENT '区',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '所在地址',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '邮箱',
  `dingtalk_openid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '钉钉openid',
  `dingtalk_unionid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '钉钉unionid',
  `dingtalk_userid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '钉钉用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1017 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_member`
--

LOCK TABLES `ms_member` WRITE;
/*!40000 ALTER TABLE `ms_member` DISABLE KEYS */;
INSERT INTO `ms_member` (`id`, `account`, `password`, `name`, `mobile`, `realname`, `create_time`, `status`, `last_login_time`, `sex`, `avatar`, `idcard`, `province`, `city`, `area`, `address`, `description`, `email`, `dingtalk_openid`, `dingtalk_unionid`, `dingtalk_userid`) VALUES (1006,'test1','e10adc3949ba59abbe56e057f20f883e','test1','13456874587','',1754561222673,1,1754561222673,0,'','',0,0,0,'','','1231@qq.com','','',''),(1007,'test123','e08a7c49d96c2b475656cc8fe18cee8e','test123','13345678910','',1754638388182,1,1754638388182,0,'https://tse2-mm.cn.bing.net/th/id/OIP-C.Wh9nRYOC13ObuoB5B2RnhgHaEo?w=290&h=181&c=7&r=0&o=5&pid=1.7','',0,0,0,'','','2484307223@qq.com','','',''),(1016,'test_member','f6fb30c15d662df432aa51fc66fada83','test_member','17711111111','',1763974524332,1,1763974524332,0,'','',0,0,0,'','','mem@ms.com','','','');
/*!40000 ALTER TABLE `ms_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_member_account`
--

DROP TABLE IF EXISTS `ms_member_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_member_account` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `member_code` bigint DEFAULT NULL COMMENT '所属账号id',
  `organization_code` bigint DEFAULT NULL COMMENT '所属组织',
  `department_code` bigint DEFAULT NULL COMMENT '部门编号',
  `authorize` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '角色',
  `is_owner` tinyint(1) DEFAULT '0' COMMENT '是否主账号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '姓名',
  `mobile` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号码',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮件',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `last_login_time` bigint DEFAULT NULL COMMENT '上次登录时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '状态0禁用 1使用中',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头像',
  `position` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职位',
  `department` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '部门',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='组织账号表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_member_account`
--

LOCK TABLES `ms_member_account` WRITE;
/*!40000 ALTER TABLE `ms_member_account` DISABLE KEYS */;
INSERT INTO `ms_member_account` (`id`, `member_code`, `organization_code`, `department_code`, `authorize`, `is_owner`, `name`, `mobile`, `email`, `create_time`, `last_login_time`, `status`, `description`, `avatar`, `position`, `department`) VALUES (1,1007,0,5,'3',1,'test123','177',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL),(35,1016,14,5,'4',0,'test_member','17711111111',NULL,NULL,NULL,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `ms_member_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_organization`
--

DROP TABLE IF EXISTS `ms_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_organization` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `avatar` varchar(511) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头像',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `member_id` bigint DEFAULT NULL COMMENT '拥有者',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `personal` tinyint(1) DEFAULT '0' COMMENT '是否个人项目',
  `address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '地址',
  `province` int DEFAULT '0' COMMENT '省',
  `city` int DEFAULT '0' COMMENT '市',
  `area` int DEFAULT '0' COMMENT '区',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='组织表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_organization`
--

LOCK TABLES `ms_organization` WRITE;
/*!40000 ALTER TABLE `ms_organization` DISABLE KEYS */;
INSERT INTO `ms_organization` (`id`, `name`, `avatar`, `description`, `member_id`, `create_time`, `personal`, `address`, `province`, `city`, `area`) VALUES (13,'test1个人组织','https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.dtstatic.com%2Fuploads%2Fblog%2F202103%2F31%2F20210331160001_9a852.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.dtstatic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673017724&t=ced22fc74624e6940fd6a89a21d30cc5','',1006,1754561222678,1,'',0,0,0),(14,'test123个人组织','https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.dtstatic.com%2Fuploads%2Fblog%2F202103%2F31%2F20210331160001_9a852.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.dtstatic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673017724&t=ced22fc74624e6940fd6a89a21d30cc5','',1007,1754638388229,1,'',0,0,0),(15,'test_member个人组织','https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.dtstatic.com%2Fuploads%2Fblog%2F202103%2F31%2F20210331160001_9a852.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.dtstatic.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673017724&t=ced22fc74624e6940fd6a89a21d30cc5','',1016,1763974524346,1,'',0,0,0);
/*!40000 ALTER TABLE `ms_organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project`
--

DROP TABLE IF EXISTS `ms_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `cover` varchar(511) DEFAULT NULL COMMENT '封面',
  `name` varchar(90) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '描述',
  `access_control_type` tinyint DEFAULT '0' COMMENT '访问控制l类型',
  `white_list` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '可以访问项目的权限组（白名单）',
  `sort` int unsigned DEFAULT '0' COMMENT '排序',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '删除标记',
  `template_code` int DEFAULT '0' COMMENT '项目类型',
  `schedule` double(5,2) DEFAULT '0.00' COMMENT '进度',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `organization_code` bigint DEFAULT NULL COMMENT '组织id',
  `deleted_time` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '删除时间',
  `private` tinyint(1) DEFAULT '1' COMMENT '是否私有',
  `prefix` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '项目前缀',
  `open_prefix` tinyint(1) DEFAULT '0' COMMENT '是否开启项目前缀',
  `archive` tinyint(1) DEFAULT '0' COMMENT '是否归档',
  `archive_time` bigint DEFAULT NULL COMMENT '归档时间',
  `open_begin_time` tinyint(1) DEFAULT '0' COMMENT '是否开启任务开始时间',
  `open_task_private` tinyint(1) DEFAULT '0' COMMENT '是否开启新任务默认开启隐私模式',
  `task_board_theme` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'default' COMMENT '看板风格',
  `begin_time` bigint DEFAULT NULL COMMENT '项目开始日期',
  `end_time` bigint DEFAULT NULL COMMENT '项目截止日期',
  `auto_update_schedule` tinyint(1) DEFAULT '0' COMMENT '自动更新项目进度',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `project` (`sort`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13052 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project`
--

LOCK TABLES `ms_project` WRITE;
/*!40000 ALTER TABLE `ms_project` DISABLE KEYS */;
INSERT INTO `ms_project` (`id`, `cover`, `name`, `description`, `access_control_type`, `white_list`, `sort`, `deleted`, `template_code`, `schedule`, `create_time`, `organization_code`, `deleted_time`, `private`, `prefix`, `open_prefix`, `archive`, `archive_time`, `open_begin_time`, `open_task_private`, `task_board_theme`, `begin_time`, `end_time`, `auto_update_schedule`) VALUES (1,'https://ts4.tc.mm.bing.net/th/id/OIP-C.gPNKQ7IWDl8wN3Kabh-PUwAAAA?w=133&h=104&c=7&bgcl=6fa74e&r=0&o=6&pid=13.1','11','11',0,NULL,1,0,0,0.00,NULL,NULL,NULL,1,NULL,0,0,NULL,0,0,'default',NULL,NULL,0),(13043,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','测试项目','test222',0,'',0,0,12,0.00,1754969182536,14,'',1,'',0,0,0,0,0,'default',0,0,0),(13044,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','测试项目1','1234567',0,'',0,0,11,0.00,1754994291512,14,'',0,'',0,0,0,0,0,'simple',0,0,0),(13045,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','测试项目2','1234567890',0,'',0,1,12,0.00,1754994884662,14,'',0,'',0,0,0,0,0,'simple',0,0,0),(13046,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','测试项目3','33333333333',0,'',0,1,12,0.00,1754996843052,14,'',0,'',0,0,0,0,0,'simple',0,0,0),(13047,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','测试项目4','444444444444444444444',0,'',0,1,11,0.00,1754997068406,14,'',0,'',0,0,0,0,0,'simple',0,0,0),(13048,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','任务步骤1','需求',0,'',0,0,12,0.00,1755225809551,14,'',0,'',0,0,0,0,0,'simple',0,0,0),(13051,'https://img2.baidu.com/it/u=792555388,2449797505&fm=253&fmt=auto&app=138&f=JPEG?w=667&h=500','文件测试','111',0,'',0,0,11,0.00,1755513014013,14,'',0,'',0,0,0,0,0,'simple',0,0,0);
/*!40000 ALTER TABLE `ms_project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_auth`
--

DROP TABLE IF EXISTS `ms_project_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_auth` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限名称',
  `status` tinyint unsigned DEFAULT '1' COMMENT '状态(0:禁用,1:启用)',
  `sort` smallint unsigned DEFAULT '0' COMMENT '排序权重',
  `desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '备注说明',
  `create_by` bigint unsigned DEFAULT '0' COMMENT '创建人',
  `create_at` bigint DEFAULT NULL COMMENT '创建时间',
  `organization_code` bigint DEFAULT NULL COMMENT '所属组织',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认',
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '权限类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_auth`
--

LOCK TABLES `ms_project_auth` WRITE;
/*!40000 ALTER TABLE `ms_project_auth` DISABLE KEYS */;
INSERT INTO `ms_project_auth` (`id`, `title`, `status`, `sort`, `desc`, `create_by`, `create_at`, `organization_code`, `is_default`, `type`) VALUES (1,'管理员',1,0,'管理员',0,1755830288343,NULL,0,'admin'),(2,'成员',1,0,'成员',0,1755830288343,NULL,1,'member'),(3,'管理员',1,0,'管理员',0,NULL,14,0,'admin'),(4,'成员',1,0,'成员',0,NULL,14,1,'member');
/*!40000 ALTER TABLE `ms_project_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_auth_node`
--

DROP TABLE IF EXISTS `ms_project_auth_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_auth_node` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `auth` bigint unsigned DEFAULT NULL COMMENT '角色ID',
  `node` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '节点路径',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_system_auth_auth` (`auth`) USING BTREE,
  KEY `index_system_auth_node` (`node`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10077 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目角色与节点绑定';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_auth_node`
--

LOCK TABLES `ms_project_auth_node` WRITE;
/*!40000 ALTER TABLE `ms_project_auth_node` DISABLE KEYS */;
INSERT INTO `ms_project_auth_node` (`id`, `auth`, `node`) VALUES (8220,2,'project'),(8221,2,'project/index'),(8222,2,'project/index/info'),(8223,2,'project/index/index'),(8224,2,'project/index/systemconfig'),(8225,2,'project/index/editpersonal'),(8226,2,'project/index/uploadavatar'),(8227,2,'project/index/changecurrentorganization'),(8228,2,'project/index/editpassword'),(8229,2,'project/index/uploadimg'),(8230,2,'project/account'),(8231,2,'project/account/index'),(8232,2,'project/account/auth'),(8233,2,'project/account/add'),(8234,2,'project/account/edit'),(8235,2,'project/account/del'),(8236,2,'project/account/forbid'),(8237,2,'project/account/resume'),(8238,2,'project/account/read'),(8239,2,'project/organization'),(8240,2,'project/organization/index'),(8241,2,'project/organization/save'),(8242,2,'project/organization/read'),(8243,2,'project/organization/edit'),(8244,2,'project/organization/delete'),(8245,2,'project/auth'),(8246,2,'project/auth/index'),(8247,2,'project/auth/add'),(8248,2,'project/auth/edit'),(8249,2,'project/auth/forbid'),(8250,2,'project/auth/resume'),(8251,2,'project/auth/del'),(8252,2,'project/auth/apply'),(8253,2,'project/auth/setdefault'),(8254,2,'project/notify'),(8255,2,'project/notify/index'),(8256,2,'project/notify/noreads'),(8257,2,'project/notify/read'),(8258,2,'project/notify/delete'),(8259,2,'project/notify/setreadied'),(8260,2,'project/notify/batchdel'),(8261,2,'project/department'),(8262,2,'project/department/index'),(8263,2,'project/department/read'),(8264,2,'project/department/save'),(8265,2,'project/department/edit'),(8266,2,'project/department/delete'),(8267,2,'project/department_member'),(8268,2,'project/department_member/index'),(8269,2,'project/department_member/searchinvitemember'),(8270,2,'project/department_member/invitemember'),(8271,2,'project/department_member/removemember'),(8272,2,'project/department_member/detail'),(8273,2,'project/department_member/uploadfile'),(8274,2,'project/menu'),(8275,2,'project/menu/menu'),(8276,2,'project/menu/menuadd'),(8277,2,'project/menu/menuedit'),(8278,2,'project/menu/menuforbid'),(8279,2,'project/menu/menuresume'),(8280,2,'project/menu/menudel'),(8281,2,'project/node'),(8282,2,'project/node/index'),(8283,2,'project/node/alllist'),(8284,2,'project/node/clear'),(8285,2,'project/node/save'),(8286,2,'project/project'),(8287,2,'project/project/index'),(8288,2,'project/project/selflist'),(8289,2,'project/project/save'),(8290,2,'project/project/read'),(8291,2,'project/project/edit'),(8292,2,'project/project/uploadcover'),(8293,2,'project/project/recycle'),(8294,2,'project/project/recovery'),(8295,2,'project/project/archive'),(8296,2,'project/project/recoveryarchive'),(8297,2,'project/project/quit'),(8298,2,'project/project/getlogbyselfproject'),(8299,2,'project/project_collect'),(8300,2,'project/project_collect/collect'),(8301,2,'project/project_member'),(8302,2,'project/project_member/index'),(8303,2,'project/project_member/searchinvitemember'),(8304,2,'project/project_member/invitemember'),(8305,2,'project/project_member/removemember'),(8306,2,'project/project_template'),(8307,2,'project/project_template/index'),(8308,2,'project/project_template/save'),(8309,2,'project/project_template/uploadcover'),(8310,2,'project/project_template/edit'),(8311,2,'project/project_template/delete'),(8312,2,'project/task'),(8313,2,'project/task/index'),(8314,2,'project/task/selflist'),(8315,2,'project/task/read'),(8316,2,'project/task/save'),(8317,2,'project/task/taskdone'),(8318,2,'project/task/assigntask'),(8319,2,'project/task/sort'),(8320,2,'project/task/createcomment'),(8321,2,'project/task/edit'),(8322,2,'project/task/like'),(8323,2,'project/task/star'),(8324,2,'project/task/recycle'),(8325,2,'project/task/recovery'),(8326,2,'project/task/delete'),(8327,2,'project/task/datetotalforproject'),(8328,2,'project/task/tasksources'),(8329,2,'project/task/tasklog'),(8330,2,'project/task/recyclebatch'),(8331,2,'project/task/setprivate'),(8332,2,'project/task/batchassigntask'),(8333,2,'project/task/tasktotags'),(8334,2,'project/task/settag'),(8335,2,'project/task/getlistbytasktag'),(8336,2,'project/task/savetaskworktime'),(8337,2,'project/task/edittaskworktime'),(8338,2,'project/task/deltaskworktime'),(8339,2,'project/task/uploadfile'),(8340,2,'project/task_member'),(8341,2,'project/task_member/index'),(8342,2,'project/task_member/searchinvitemember'),(8343,2,'project/task_member/invitemember'),(8344,2,'project/task_member/invitememberbatch'),(8345,2,'project/task_stages'),(8346,2,'project/task_stages/index'),(8347,2,'project/task_stages/tasks'),(8348,2,'project/task_stages/sort'),(8349,2,'project/task_stages/save'),(8350,2,'project/task_stages/edit'),(8351,2,'project/task_stages/delete'),(8352,2,'project/task_stages_template'),(8353,2,'project/task_stages_template/index'),(8354,2,'project/task_stages_template/save'),(8355,2,'project/task_stages_template/edit'),(8356,2,'project/task_stages_template/delete'),(8357,2,'project/file'),(8358,2,'project/file/index'),(8359,2,'project/file/read'),(8360,2,'project/file/uploadfiles'),(8361,2,'project/file/edit'),(8362,2,'project/file/recycle'),(8363,2,'project/file/recovery'),(8364,2,'project/file/delete'),(8365,2,'project/source_link'),(8366,2,'project/source_link/delete'),(8367,2,'project/invite_link'),(8368,2,'project/invite_link/save'),(8369,2,'project/task_tag'),(8370,2,'project/task_tag/index'),(8371,2,'project/task_tag/save'),(8372,2,'project/task_tag/edit'),(8373,2,'project/task_tag/delete'),(8374,2,'project/project_features'),(8375,2,'project/project_features/index'),(8376,2,'project/project_features/save'),(8377,2,'project/project_features/edit'),(8378,2,'project/project_features/delete'),(8379,2,'project/project_version'),(8380,2,'project/project_version/index'),(8381,2,'project/project_version/save'),(8382,2,'project/project_version/edit'),(8383,2,'project/project_version/changestatus'),(8384,2,'project/project_version/read'),(8385,2,'project/project_version/addversiontask'),(8386,2,'project/project_version/removeversiontask'),(8387,2,'project/project_version/delete'),(8388,2,'project/task_workflow'),(8389,2,'project/task_workflow/index'),(8390,2,'project/task_workflow/save'),(8391,2,'project/task_workflow/edit'),(8392,2,'project/task_workflow/delete'),(8393,1,'project'),(8394,1,'project/index'),(8395,1,'project/index/info'),(8396,1,'project/index/index'),(8397,1,'project/index/systemconfig'),(8398,1,'project/index/editpersonal'),(8399,1,'project/index/uploadavatar'),(8400,1,'project/index/changecurrentorganization'),(8401,1,'project/index/editpassword'),(8402,1,'project/index/uploadimg'),(8403,1,'project/account'),(8404,1,'project/account/index'),(8405,1,'project/account/auth'),(8406,1,'project/account/add'),(8407,1,'project/account/edit'),(8408,1,'project/account/del'),(8409,1,'project/account/forbid'),(8410,1,'project/account/resume'),(8411,1,'project/account/read'),(8412,1,'project/organization'),(8413,1,'project/organization/index'),(8414,1,'project/organization/save'),(8415,1,'project/organization/read'),(8416,1,'project/organization/edit'),(8417,1,'project/organization/delete'),(8418,1,'project/auth'),(8419,1,'project/auth/index'),(8420,1,'project/auth/add'),(8421,1,'project/auth/edit'),(8422,1,'project/auth/forbid'),(8423,1,'project/auth/resume'),(8424,1,'project/auth/del'),(8425,1,'project/auth/apply'),(8426,1,'project/auth/setdefault'),(8427,1,'project/notify'),(8428,1,'project/notify/index'),(8429,1,'project/notify/noreads'),(8430,1,'project/notify/read'),(8431,1,'project/notify/delete'),(8432,1,'project/notify/setreadied'),(8433,1,'project/notify/batchdel'),(8434,1,'project/department'),(8435,1,'project/department/index'),(8436,1,'project/department/read'),(8437,1,'project/department/save'),(8438,1,'project/department/edit'),(8439,1,'project/department/delete'),(8440,1,'project/department_member'),(8441,1,'project/department_member/index'),(8442,1,'project/department_member/searchinvitemember'),(8443,1,'project/department_member/invitemember'),(8444,1,'project/department_member/removemember'),(8445,1,'project/department_member/detail'),(8446,1,'project/department_member/uploadfile'),(8447,1,'project/menu'),(8448,1,'project/menu/menu'),(8449,1,'project/menu/menuadd'),(8450,1,'project/menu/menuedit'),(8451,1,'project/menu/menuforbid'),(8452,1,'project/menu/menuresume'),(8453,1,'project/menu/menudel'),(8454,1,'project/node'),(8455,1,'project/node/index'),(8456,1,'project/node/alllist'),(8457,1,'project/node/clear'),(8458,1,'project/node/save'),(8459,1,'project/project'),(8460,1,'project/project/index'),(8461,1,'project/project/selflist'),(8462,1,'project/project/save'),(8463,1,'project/project/read'),(8464,1,'project/project/edit'),(8465,1,'project/project/uploadcover'),(8466,1,'project/project/recycle'),(8467,1,'project/project/recovery'),(8468,1,'project/project/archive'),(8469,1,'project/project/recoveryarchive'),(8470,1,'project/project/quit'),(8471,1,'project/project/getlogbyselfproject'),(8472,1,'project/project_collect'),(8473,1,'project/project_collect/collect'),(8474,1,'project/project_member'),(8475,1,'project/project_member/index'),(8476,1,'project/project_member/searchinvitemember'),(8477,1,'project/project_member/invitemember'),(8478,1,'project/project_member/removemember'),(8479,1,'project/project_template'),(8480,1,'project/project_template/index'),(8481,1,'project/project_template/save'),(8482,1,'project/project_template/uploadcover'),(8483,1,'project/project_template/edit'),(8484,1,'project/project_template/delete'),(8485,1,'project/task'),(8486,1,'project/task/index'),(8487,1,'project/task/selflist'),(8488,1,'project/task/read'),(8489,1,'project/task/save'),(8490,1,'project/task/taskdone'),(8491,1,'project/task/assigntask'),(8492,1,'project/task/sort'),(8493,1,'project/task/createcomment'),(8494,1,'project/task/edit'),(8495,1,'project/task/like'),(8496,1,'project/task/star'),(8497,1,'project/task/recycle'),(8498,1,'project/task/recovery'),(8499,1,'project/task/delete'),(8500,1,'project/task/datetotalforproject'),(8501,1,'project/task/tasksources'),(8502,1,'project/task/tasklog'),(8503,1,'project/task/recyclebatch'),(8504,1,'project/task/setprivate'),(8505,1,'project/task/batchassigntask'),(8506,1,'project/task/tasktotags'),(8507,1,'project/task/settag'),(8508,1,'project/task/getlistbytasktag'),(8509,1,'project/task/savetaskworktime'),(8510,1,'project/task/edittaskworktime'),(8511,1,'project/task/deltaskworktime'),(8512,1,'project/task/uploadfile'),(8513,1,'project/task_member'),(8514,1,'project/task_member/index'),(8515,1,'project/task_member/searchinvitemember'),(8516,1,'project/task_member/invitemember'),(8517,1,'project/task_member/invitememberbatch'),(8518,1,'project/task_stages'),(8519,1,'project/task_stages/index'),(8520,1,'project/task_stages/tasks'),(8521,1,'project/task_stages/sort'),(8522,1,'project/task_stages/save'),(8523,1,'project/task_stages/edit'),(8524,1,'project/task_stages/delete'),(8525,1,'project/task_stages_template'),(8526,1,'project/task_stages_template/index'),(8527,1,'project/task_stages_template/save'),(8528,1,'project/task_stages_template/edit'),(8529,1,'project/task_stages_template/delete'),(8530,1,'project/file'),(8531,1,'project/file/index'),(8532,1,'project/file/read'),(8533,1,'project/file/uploadfiles'),(8534,1,'project/file/edit'),(8535,1,'project/file/recycle'),(8536,1,'project/file/recovery'),(8537,1,'project/file/delete'),(8538,1,'project/source_link'),(8539,1,'project/source_link/delete'),(8540,1,'project/invite_link'),(8541,1,'project/invite_link/save'),(8542,1,'project/task_tag'),(8543,1,'project/task_tag/index'),(8544,1,'project/task_tag/save'),(8545,1,'project/task_tag/edit'),(8546,1,'project/task_tag/delete'),(8547,1,'project/project_features'),(8548,1,'project/project_features/index'),(8549,1,'project/project_features/save'),(8550,1,'project/project_features/edit'),(8551,1,'project/project_features/delete'),(8552,1,'project/project_version'),(8553,1,'project/project_version/index'),(8554,1,'project/project_version/save'),(8555,1,'project/project_version/edit'),(8556,1,'project/project_version/changestatus'),(8557,1,'project/project_version/read'),(8558,1,'project/project_version/addversiontask'),(8559,1,'project/project_version/removeversiontask'),(8560,1,'project/project_version/delete'),(8561,1,'project/task_workflow'),(8562,1,'project/task_workflow/index'),(8563,1,'project/task_workflow/save'),(8564,1,'project/task_workflow/edit'),(8565,1,'project/task_workflow/delete'),(8739,5,'project/index'),(8740,5,'project/index/info'),(8741,5,'project/index/index'),(8742,5,'project/index/systemconfig'),(8743,5,'project/index/editpersonal'),(8744,5,'project/index/uploadavatar'),(8745,5,'project/index/changecurrentorganization'),(8746,5,'project/index/editpassword'),(8747,5,'project/index/uploadimg'),(8748,5,'project/organization'),(8749,5,'project/organization/index'),(8750,5,'project/organization/save'),(8751,5,'project/organization/read'),(8752,5,'project/organization/edit'),(8753,5,'project/organization/delete'),(8754,5,'project/auth'),(8755,5,'project/auth/index'),(8756,5,'project/auth/add'),(8757,5,'project/auth/edit'),(8758,5,'project/auth/forbid'),(8759,5,'project/auth/resume'),(8760,5,'project/auth/del'),(8761,5,'project/auth/apply'),(8762,5,'project/auth/setdefault'),(8763,5,'project/notify'),(8764,5,'project/notify/index'),(8765,5,'project/notify/noreads'),(8766,5,'project/notify/read'),(8767,5,'project/notify/delete'),(8768,5,'project/notify/setreadied'),(8769,5,'project/notify/batchdel'),(8770,5,'project/department'),(8771,5,'project/department/index'),(8772,5,'project/department/read'),(8773,5,'project/department/save'),(8774,5,'project/department/edit'),(8775,5,'project/department/delete'),(8776,5,'project/department_member'),(8777,5,'project/department_member/index'),(8778,5,'project/department_member/searchinvitemember'),(8779,5,'project/department_member/invitemember'),(8780,5,'project/department_member/removemember'),(8781,5,'project/department_member/detail'),(8782,5,'project/department_member/uploadfile'),(8783,5,'project/menu'),(8784,5,'project/menu/menu'),(8785,5,'project/menu/menuadd'),(8786,5,'project/menu/menuedit'),(8787,5,'project/menu/menuforbid'),(8788,5,'project/menu/menuresume'),(8789,5,'project/menu/menudel'),(8790,5,'project/node'),(8791,5,'project/node/index'),(8792,5,'project/node/alllist'),(8793,5,'project/node/clear'),(8794,5,'project/node/save'),(8795,5,'project/project'),(8796,5,'project/project/index'),(8797,5,'project/project/selflist'),(8798,5,'project/project/save'),(8799,5,'project/project/read'),(8800,5,'project/project/edit'),(8801,5,'project/project/uploadcover'),(8802,5,'project/project/recycle'),(8803,5,'project/project/recovery'),(8804,5,'project/project/archive'),(8805,5,'project/project/recoveryarchive'),(8806,5,'project/project/quit'),(8807,5,'project/project/getlogbyselfproject'),(8808,5,'project/project_collect'),(8809,5,'project/project_collect/collect'),(8810,5,'project/project_member'),(8811,5,'project/project_member/index'),(8812,5,'project/project_member/searchinvitemember'),(8813,5,'project/project_member/invitemember'),(8814,5,'project/project_member/removemember'),(8815,5,'project/project_template'),(8816,5,'project/project_template/index'),(8817,5,'project/project_template/save'),(8818,5,'project/project_template/uploadcover'),(8819,5,'project/project_template/edit'),(8820,5,'project/project_template/delete'),(8821,5,'project/task'),(8822,5,'project/task/index'),(8823,5,'project/task/selflist'),(8824,5,'project/task/read'),(8825,5,'project/task/save'),(8826,5,'project/task/taskdone'),(8827,5,'project/task/assigntask'),(8828,5,'project/task/sort'),(8829,5,'project/task/createcomment'),(8830,5,'project/task/edit'),(8831,5,'project/task/like'),(8832,5,'project/task/star'),(8833,5,'project/task/recycle'),(8834,5,'project/task/recovery'),(8835,5,'project/task/delete'),(8836,5,'project/task/datetotalforproject'),(8837,5,'project/task/tasksources'),(8838,5,'project/task/tasklog'),(8839,5,'project/task/recyclebatch'),(8840,5,'project/task/setprivate'),(8841,5,'project/task/batchassigntask'),(8842,5,'project/task/tasktotags'),(8843,5,'project/task/settag'),(8844,5,'project/task/getlistbytasktag'),(8845,5,'project/task/savetaskworktime'),(8846,5,'project/task/edittaskworktime'),(8847,5,'project/task/deltaskworktime'),(8848,5,'project/task/uploadfile'),(8849,5,'project/task_member'),(8850,5,'project/task_member/index'),(8851,5,'project/task_member/searchinvitemember'),(8852,5,'project/task_member/invitemember'),(8853,5,'project/task_member/invitememberbatch'),(8854,5,'project/task_stages'),(8855,5,'project/task_stages/index'),(8856,5,'project/task_stages/tasks'),(8857,5,'project/task_stages/sort'),(8858,5,'project/task_stages/save'),(8859,5,'project/task_stages/edit'),(8860,5,'project/task_stages/delete'),(8861,5,'project/task_stages_template'),(8862,5,'project/task_stages_template/index'),(8863,5,'project/task_stages_template/save'),(8864,5,'project/task_stages_template/edit'),(8865,5,'project/task_stages_template/delete'),(8866,5,'project/file'),(8867,5,'project/file/index'),(8868,5,'project/file/read'),(8869,5,'project/file/uploadfiles'),(8870,5,'project/file/edit'),(8871,5,'project/file/recycle'),(8872,5,'project/file/recovery'),(8873,5,'project/file/delete'),(8874,5,'project/source_link'),(8875,5,'project/source_link/delete'),(8876,5,'project/invite_link'),(8877,5,'project/invite_link/save'),(8878,5,'project/task_tag'),(8879,5,'project/task_tag/index'),(8880,5,'project/task_tag/save'),(8881,5,'project/task_tag/edit'),(8882,5,'project/task_tag/delete'),(8883,5,'project/project_features'),(8884,5,'project/project_features/index'),(8885,5,'project/project_features/save'),(8886,5,'project/project_features/edit'),(8887,5,'project/project_features/delete'),(8888,5,'project/project_version'),(8889,5,'project/project_version/index'),(8890,5,'project/project_version/save'),(8891,5,'project/project_version/edit'),(8892,5,'project/project_version/changestatus'),(8893,5,'project/project_version/read'),(8894,5,'project/project_version/addversiontask'),(8895,5,'project/project_version/removeversiontask'),(8896,5,'project/project_version/delete'),(8897,5,'project/task_workflow'),(8898,5,'project/task_workflow/index'),(8899,5,'project/task_workflow/save'),(8900,5,'project/task_workflow/edit'),(8901,5,'project/task_workflow/delete'),(9746,3,'project/auth'),(9747,3,'project/auth/index'),(9748,3,'project/auth/add'),(9749,3,'project/auth/edit'),(9750,3,'project/auth/forbid'),(9751,3,'project/auth/resume'),(9752,3,'project/auth/del'),(9753,3,'project/auth/apply'),(9754,3,'project/auth/setdefault'),(9755,3,'project'),(9756,3,'project/index'),(9757,3,'project/index/info'),(9758,3,'project/index/index'),(9759,3,'project/index/systemconfig'),(9760,3,'project/index/editpersonal'),(9761,3,'project/index/uploadavatar'),(9762,3,'project/index/changecurrentorganization'),(9763,3,'project/index/editpassword'),(9764,3,'project/index/uploadimg'),(9765,3,'project/account'),(9766,3,'project/account/index'),(9767,3,'project/account/auth'),(9768,3,'project/account/add'),(9769,3,'project/account/edit'),(9770,3,'project/account/del'),(9771,3,'project/account/forbid'),(9772,3,'project/account/resume'),(9773,3,'project/account/read'),(9774,3,'project/organization'),(9775,3,'project/organization/index'),(9776,3,'project/organization/save'),(9777,3,'project/organization/read'),(9778,3,'project/organization/edit'),(9779,3,'project/organization/delete'),(9780,3,'project/notify'),(9781,3,'project/notify/index'),(9782,3,'project/notify/noreads'),(9783,3,'project/notify/read'),(9784,3,'project/notify/delete'),(9785,3,'project/notify/setreadied'),(9786,3,'project/notify/batchdel'),(9787,3,'project/department'),(9788,3,'project/department/index'),(9789,3,'project/department/read'),(9790,3,'project/department/save'),(9791,3,'project/department/edit'),(9792,3,'project/department/delete'),(9793,3,'project/department_member'),(9794,3,'project/department_member/index'),(9795,3,'project/department_member/searchinvitemember'),(9796,3,'project/department_member/invitemember'),(9797,3,'project/department_member/removemember'),(9798,3,'project/department_member/detail'),(9799,3,'project/department_member/uploadfile'),(9800,3,'project/menu'),(9801,3,'project/menu/menu'),(9802,3,'project/menu/menuadd'),(9803,3,'project/menu/menuedit'),(9804,3,'project/menu/menuforbid'),(9805,3,'project/menu/menuresume'),(9806,3,'project/menu/menudel'),(9807,3,'project/node'),(9808,3,'project/node/index'),(9809,3,'project/node/alllist'),(9810,3,'project/node/clear'),(9811,3,'project/node/save'),(9812,3,'project/project'),(9813,3,'project/project/index'),(9814,3,'project/project/selflist'),(9815,3,'project/project/save'),(9816,3,'project/project/read'),(9817,3,'project/project/edit'),(9818,3,'project/project/uploadcover'),(9819,3,'project/project/recycle'),(9820,3,'project/project/recovery'),(9821,3,'project/project/archive'),(9822,3,'project/project/recoveryarchive'),(9823,3,'project/project/quit'),(9824,3,'project/project/getlogbyselfproject'),(9825,3,'project/project_collect'),(9826,3,'project/project_collect/collect'),(9827,3,'project/project_member'),(9828,3,'project/project_member/index'),(9829,3,'project/project_member/searchinvitemember'),(9830,3,'project/project_member/invitemember'),(9831,3,'project/project_member/removemember'),(9832,3,'project/project_template'),(9833,3,'project/project_template/index'),(9834,3,'project/project_template/save'),(9835,3,'project/project_template/uploadcover'),(9836,3,'project/project_template/edit'),(9837,3,'project/project_template/delete'),(9838,3,'project/task'),(9839,3,'project/task/index'),(9840,3,'project/task/selflist'),(9841,3,'project/task/read'),(9842,3,'project/task/save'),(9843,3,'project/task/taskdone'),(9844,3,'project/task/assigntask'),(9845,3,'project/task/sort'),(9846,3,'project/task/createcomment'),(9847,3,'project/task/edit'),(9848,3,'project/task/like'),(9849,3,'project/task/star'),(9850,3,'project/task/recycle'),(9851,3,'project/task/recovery'),(9852,3,'project/task/delete'),(9853,3,'project/task/datetotalforproject'),(9854,3,'project/task/tasksources'),(9855,3,'project/task/tasklog'),(9856,3,'project/task/recyclebatch'),(9857,3,'project/task/setprivate'),(9858,3,'project/task/batchassigntask'),(9859,3,'project/task/tasktotags'),(9860,3,'project/task/settag'),(9861,3,'project/task/getlistbytasktag'),(9862,3,'project/task/savetaskworktime'),(9863,3,'project/task/edittaskworktime'),(9864,3,'project/task/deltaskworktime'),(9865,3,'project/task/uploadfile'),(9866,3,'project/task_member'),(9867,3,'project/task_member/index'),(9868,3,'project/task_member/searchinvitemember'),(9869,3,'project/task_member/invitemember'),(9870,3,'project/task_member/invitememberbatch'),(9871,3,'project/task_stages'),(9872,3,'project/task_stages/index'),(9873,3,'project/task_stages/tasks'),(9874,3,'project/task_stages/sort'),(9875,3,'project/task_stages/save'),(9876,3,'project/task_stages/edit'),(9877,3,'project/task_stages/delete'),(9878,3,'project/task_stages_template'),(9879,3,'project/task_stages_template/index'),(9880,3,'project/task_stages_template/save'),(9881,3,'project/task_stages_template/edit'),(9882,3,'project/task_stages_template/delete'),(9883,3,'project/file'),(9884,3,'project/file/index'),(9885,3,'project/file/read'),(9886,3,'project/file/uploadfiles'),(9887,3,'project/file/edit'),(9888,3,'project/file/recycle'),(9889,3,'project/file/recovery'),(9890,3,'project/file/delete'),(9891,3,'project/source_link'),(9892,3,'project/source_link/delete'),(9893,3,'project/invite_link'),(9894,3,'project/invite_link/save'),(9895,3,'project/task_tag'),(9896,3,'project/task_tag/index'),(9897,3,'project/task_tag/save'),(9898,3,'project/task_tag/edit'),(9899,3,'project/task_tag/delete'),(9900,3,'project/project_features'),(9901,3,'project/project_features/index'),(9902,3,'project/project_features/save'),(9903,3,'project/project_features/edit'),(9904,3,'project/project_features/delete'),(9905,3,'project/project_version'),(9906,3,'project/project_version/index'),(9907,3,'project/project_version/save'),(9908,3,'project/project_version/edit'),(9909,3,'project/project_version/changestatus'),(9910,3,'project/project_version/read'),(9911,3,'project/project_version/addversiontask'),(9912,3,'project/project_version/removeversiontask'),(9913,3,'project/project_version/delete'),(9914,3,'project/task_workflow'),(9915,3,'project/task_workflow/index'),(9916,3,'project/task_workflow/save'),(9917,3,'project/task_workflow/edit'),(9918,3,'project/task_workflow/delete'),(9919,4,'project/index'),(9920,4,'project/index/info'),(9921,4,'project/index/index'),(9922,4,'project/index/systemconfig'),(9923,4,'project/index/editpersonal'),(9924,4,'project/index/uploadavatar'),(9925,4,'project/index/changecurrentorganization'),(9926,4,'project/index/editpassword'),(9927,4,'project/index/uploadimg'),(9928,4,'project/account'),(9929,4,'project/account/index'),(9930,4,'project/account/auth'),(9931,4,'project/account/add'),(9932,4,'project/account/edit'),(9933,4,'project/account/del'),(9934,4,'project/account/forbid'),(9935,4,'project/account/resume'),(9936,4,'project/account/read'),(9937,4,'project/organization'),(9938,4,'project/organization/index'),(9939,4,'project/organization/save'),(9940,4,'project/organization/read'),(9941,4,'project/organization/edit'),(9942,4,'project/organization/delete'),(9943,4,'project/notify'),(9944,4,'project/notify/index'),(9945,4,'project/notify/noreads'),(9946,4,'project/notify/read'),(9947,4,'project/notify/delete'),(9948,4,'project/notify/setreadied'),(9949,4,'project/notify/batchdel'),(9950,4,'project/department'),(9951,4,'project/department/index'),(9952,4,'project/department/read'),(9953,4,'project/department/save'),(9954,4,'project/department/edit'),(9955,4,'project/department/delete'),(9956,4,'project/department_member'),(9957,4,'project/department_member/index'),(9958,4,'project/department_member/searchinvitemember'),(9959,4,'project/department_member/invitemember'),(9960,4,'project/department_member/removemember'),(9961,4,'project/department_member/detail'),(9962,4,'project/department_member/uploadfile'),(9963,4,'project/menu'),(9964,4,'project/menu/menu'),(9965,4,'project/menu/menuadd'),(9966,4,'project/menu/menuedit'),(9967,4,'project/menu/menuforbid'),(9968,4,'project/menu/menuresume'),(9969,4,'project/menu/menudel'),(9970,4,'project/project'),(9971,4,'project/project/index'),(9972,4,'project/project/selflist'),(9973,4,'project/project/save'),(9974,4,'project/project/read'),(9975,4,'project/project/edit'),(9976,4,'project/project/uploadcover'),(9977,4,'project/project/recycle'),(9978,4,'project/project/recovery'),(9979,4,'project/project/archive'),(9980,4,'project/project/recoveryarchive'),(9981,4,'project/project/quit'),(9982,4,'project/project/getlogbyselfproject'),(9983,4,'project/project_collect'),(9984,4,'project/project_collect/collect'),(9985,4,'project/project_member'),(9986,4,'project/project_member/index'),(9987,4,'project/project_member/searchinvitemember'),(9988,4,'project/project_member/invitemember'),(9989,4,'project/project_member/removemember'),(9990,4,'project/project_template'),(9991,4,'project/project_template/index'),(9992,4,'project/project_template/save'),(9993,4,'project/project_template/uploadcover'),(9994,4,'project/project_template/edit'),(9995,4,'project/project_template/delete'),(9996,4,'project/task'),(9997,4,'project/task/index'),(9998,4,'project/task/selflist'),(9999,4,'project/task/read'),(10000,4,'project/task/save'),(10001,4,'project/task/taskdone'),(10002,4,'project/task/assigntask'),(10003,4,'project/task/sort'),(10004,4,'project/task/createcomment'),(10005,4,'project/task/edit'),(10006,4,'project/task/like'),(10007,4,'project/task/star'),(10008,4,'project/task/recycle'),(10009,4,'project/task/recovery'),(10010,4,'project/task/delete'),(10011,4,'project/task/datetotalforproject'),(10012,4,'project/task/tasksources'),(10013,4,'project/task/tasklog'),(10014,4,'project/task/recyclebatch'),(10015,4,'project/task/setprivate'),(10016,4,'project/task/batchassigntask'),(10017,4,'project/task/tasktotags'),(10018,4,'project/task/settag'),(10019,4,'project/task/getlistbytasktag'),(10020,4,'project/task/savetaskworktime'),(10021,4,'project/task/edittaskworktime'),(10022,4,'project/task/deltaskworktime'),(10023,4,'project/task/uploadfile'),(10024,4,'project/task_member'),(10025,4,'project/task_member/index'),(10026,4,'project/task_member/searchinvitemember'),(10027,4,'project/task_member/invitemember'),(10028,4,'project/task_member/invitememberbatch'),(10029,4,'project/task_stages'),(10030,4,'project/task_stages/index'),(10031,4,'project/task_stages/tasks'),(10032,4,'project/task_stages/sort'),(10033,4,'project/task_stages/save'),(10034,4,'project/task_stages/edit'),(10035,4,'project/task_stages/delete'),(10036,4,'project/task_stages_template'),(10037,4,'project/task_stages_template/index'),(10038,4,'project/task_stages_template/save'),(10039,4,'project/task_stages_template/edit'),(10040,4,'project/task_stages_template/delete'),(10041,4,'project/file'),(10042,4,'project/file/index'),(10043,4,'project/file/read'),(10044,4,'project/file/uploadfiles'),(10045,4,'project/file/edit'),(10046,4,'project/file/recycle'),(10047,4,'project/file/recovery'),(10048,4,'project/file/delete'),(10049,4,'project/source_link'),(10050,4,'project/source_link/delete'),(10051,4,'project/invite_link'),(10052,4,'project/invite_link/save'),(10053,4,'project/task_tag'),(10054,4,'project/task_tag/index'),(10055,4,'project/task_tag/save'),(10056,4,'project/task_tag/edit'),(10057,4,'project/task_tag/delete'),(10058,4,'project/project_features'),(10059,4,'project/project_features/index'),(10060,4,'project/project_features/save'),(10061,4,'project/project_features/edit'),(10062,4,'project/project_features/delete'),(10063,4,'project/project_version'),(10064,4,'project/project_version/index'),(10065,4,'project/project_version/save'),(10066,4,'project/project_version/edit'),(10067,4,'project/project_version/changestatus'),(10068,4,'project/project_version/read'),(10069,4,'project/project_version/addversiontask'),(10070,4,'project/project_version/removeversiontask'),(10071,4,'project/project_version/delete'),(10072,4,'project/task_workflow'),(10073,4,'project/task_workflow/index'),(10074,4,'project/task_workflow/save'),(10075,4,'project/task_workflow/edit'),(10076,4,'project/task_workflow/delete');
/*!40000 ALTER TABLE `ms_project_auth_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_collection`
--

DROP TABLE IF EXISTS `ms_project_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_collection` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_code` bigint DEFAULT '0' COMMENT '项目id',
  `member_code` bigint DEFAULT '0' COMMENT '成员id',
  `create_time` bigint DEFAULT '0' COMMENT '加入时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目-收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_collection`
--

LOCK TABLES `ms_project_collection` WRITE;
/*!40000 ALTER TABLE `ms_project_collection` DISABLE KEYS */;
INSERT INTO `ms_project_collection` (`id`, `project_code`, `member_code`, `create_time`) VALUES (46,1,1007,0),(57,13044,1007,1755139412950),(62,13043,1007,1763973780115);
/*!40000 ALTER TABLE `ms_project_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_log`
--

DROP TABLE IF EXISTS `ms_project_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `member_code` bigint DEFAULT '0' COMMENT '操作人id',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '操作内容',
  `remark` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT 'create' COMMENT '操作类型',
  `create_time` bigint DEFAULT NULL COMMENT '添加时间',
  `source_code` bigint DEFAULT '0' COMMENT '任务id',
  `action_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '场景类型',
  `to_member_code` bigint DEFAULT '0',
  `is_comment` tinyint(1) DEFAULT '0' COMMENT '是否评论，0：否',
  `project_code` bigint DEFAULT NULL,
  `icon` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `is_robot` tinyint(1) DEFAULT '0' COMMENT '是否机器人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `member_code` (`member_code`) USING BTREE,
  KEY `source_code` (`source_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5092 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='项目日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_log`
--

LOCK TABLES `ms_project_log` WRITE;
/*!40000 ALTER TABLE `ms_project_log` DISABLE KEYS */;
INSERT INTO `ms_project_log` (`id`, `member_code`, `content`, `remark`, `type`, `create_time`, `source_code`, `action_type`, `to_member_code`, `is_comment`, `project_code`, `icon`, `is_robot`) VALUES (5086,1007,'666','创建了任务','create',1755490265333,12377,'task',0,0,13048,'plus',0),(5087,1007,'文件1','创建了任务','create',1755513020727,12378,'task',0,0,13051,'plus',0),(5088,1007,'文件2','创建了任务','create',1755513023228,12379,'task',0,0,13051,'plus',0),(5089,1007,'评论1','评论1','createComment',1755589342977,12379,'task',0,1,13051,'plus',0),(5090,1007,'文件3','创建了任务','create',1755589718819,12380,'task',0,0,13051,'plus',0),(5091,1007,'123@test123 ','123@test123 ','createComment',1755590157412,12380,'task',0,1,13051,'plus',0);
/*!40000 ALTER TABLE `ms_project_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_member`
--

DROP TABLE IF EXISTS `ms_project_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_code` bigint DEFAULT NULL COMMENT '项目id',
  `member_code` bigint DEFAULT NULL COMMENT '成员id',
  `join_time` bigint DEFAULT NULL COMMENT '加入时间',
  `is_owner` bigint DEFAULT '0' COMMENT '拥有者',
  `authorize` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '角色',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`project_code`,`member_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目-成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_member`
--

LOCK TABLES `ms_project_member` WRITE;
/*!40000 ALTER TABLE `ms_project_member` DISABLE KEYS */;
INSERT INTO `ms_project_member` (`id`, `project_code`, `member_code`, `join_time`, `is_owner`, `authorize`) VALUES (37,13043,1007,1754969182566,1007,''),(112,1,1007,NULL,1007,'75'),(113,13044,1007,1754994291542,1007,''),(114,13045,1007,1754994884676,1007,''),(115,13046,1007,1754996843071,1007,''),(116,13047,1007,1754997068433,1007,''),(117,13048,1007,1755225809571,1007,''),(118,13049,1007,1755225833193,1007,''),(119,13050,1007,1755226103014,1007,''),(120,13051,1007,1755513014019,1007,'');
/*!40000 ALTER TABLE `ms_project_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_menu`
--

DROP TABLE IF EXISTS `ms_project_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_menu` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pid` bigint unsigned NOT NULL DEFAULT '0' COMMENT '父id',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '名称',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '菜单图标',
  `url` varchar(400) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '链接',
  `file_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '文件路径',
  `params` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '链接参数',
  `node` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '#' COMMENT '权限节点',
  `sort` int unsigned DEFAULT '0' COMMENT '菜单排序',
  `status` tinyint unsigned DEFAULT '1' COMMENT '状态(0:禁用,1:启用)',
  `create_by` bigint unsigned NOT NULL DEFAULT '0' COMMENT '创建人',
  `is_inner` tinyint(1) DEFAULT '0' COMMENT '是否内页',
  `values` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '参数默认值',
  `show_slider` tinyint(1) DEFAULT '1' COMMENT '是否显示侧栏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=176 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='项目菜单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_menu`
--

LOCK TABLES `ms_project_menu` WRITE;
/*!40000 ALTER TABLE `ms_project_menu` DISABLE KEYS */;
INSERT INTO `ms_project_menu` (`id`, `pid`, `title`, `icon`, `url`, `file_path`, `params`, `node`, `sort`, `status`, `create_by`, `is_inner`, `values`, `show_slider`) VALUES (120,0,'工作台','appstore-o','home','home',':org','#',0,1,0,0,'',0),(121,0,'项目管理','project','#','#','','#',0,1,0,0,'',1),(122,121,'项目列表','branches','#','#','','#',0,1,0,0,'',1),(124,0,'系统设置','setting','#','#','','#',100,1,0,0,'',1),(125,124,'成员管理','unlock','#','#','','#',10,1,0,0,'',1),(126,125,'账号列表','','system/account','system/account','','project/account/index',10,1,0,0,'',1),(127,122,'我的组织','','organization','organization','','project/organization/index',30,1,0,0,'',1),(130,125,'访问授权','','system/account/auth','system/account/auth','','project/auth/index',20,1,0,0,'',1),(131,125,'授权页面','','system/account/apply','system/account/apply',':id','project/auth/apply',30,1,0,1,'',1),(138,121,'消息提醒','info-circle-o','#','#','','#',30,1,0,0,'',1),(139,138,'站内消息','','notify/notice','notify/notice','','project/notify/index',0,1,0,0,'',1),(140,138,'系统公告','','notify/system','notify/system','','project/notify/index',10,1,0,0,'',1),(143,124,'系统管理','appstore','#','#','','#',0,1,0,0,'',1),(144,143,'菜单路由','','system/config/menu','system/config/menu','','project/menu/menuadd',0,1,0,0,'',1),(145,143,'访问节点','','system/config/node','system/config/node','','project/node/save',0,1,0,0,'',1),(148,124,'个人管理','user','#','#','','#',0,1,0,0,'',1),(149,148,'个人设置','','account/setting/base','account/setting/base','','project/index/editpersonal',0,1,0,0,'',1),(150,148,'安全设置','','account/setting/security','account/setting/security','','project/index/editpersonal',0,1,0,1,'',1),(151,122,'我的项目','','project/list','project/list',':type','project/project/index',0,1,0,0,'my',1),(152,122,'回收站','','project/recycle','project/recycle','','project/project/index',20,1,0,0,'',1),(153,121,'项目空间','heat-map','project/space/task','project/space/task',':code','#',20,1,0,1,'',1),(154,153,'任务详情','','project/space/task/:code/detail','project/space/taskdetail',':code','project/task/read',0,1,0,1,'',0),(155,122,'我的收藏','','project/list','project/list',':type','project/project/index',10,1,0,0,'collect',1),(156,121,'基础设置','experiment','#','#','','#',0,1,0,0,'',1),(157,156,'项目模板','','project/template','project/template','','project/project_template/index',0,1,0,0,'',1),(158,156,'项目列表模板','','project/template/taskStages','project/template/taskStages',':code','project/task_stages_template/index',0,1,0,1,'',0),(159,122,'已归档项目','','project/archive','project/archive','','project/project/index',10,1,0,0,'',1),(160,0,'团队成员','team','#','#','','#',0,1,0,1,'',0),(161,153,'项目概况','','project/space/overview','project/space/overview',':code','project/index/info',20,1,0,1,'',0),(162,153,'项目文件','','project/space/files','project/space/files',':code','project/index/info',10,1,0,1,'',0),(163,122,'项目分析','','project/analysis','project/analysis','','project/index/info',5,1,0,0,'',1),(164,160,'团队成员','','#','#','','#',0,1,0,1,'',0),(166,164,'团队成员','','members','members','','project/department/index',0,1,0,1,'',0),(167,164,'成员信息','','members/profile','members/profile',':code','project/department/read',0,1,0,1,'',0),(168,153,'版本管理','','project/space/features','project/space/features',':code','project/index/info',20,1,0,1,'',0);
/*!40000 ALTER TABLE `ms_project_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_node`
--

DROP TABLE IF EXISTS `ms_project_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_node` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `node` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '节点代码',
  `title` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '节点标题',
  `is_menu` tinyint unsigned DEFAULT '0' COMMENT '是否可设置为菜单',
  `is_auth` tinyint unsigned DEFAULT '1' COMMENT '是否启动RBAC权限控制',
  `is_login` tinyint unsigned DEFAULT '1' COMMENT '是否启动登录控制',
  `create_at` bigint DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_system_node_node` (`node`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=641 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目端节点表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_node`
--

LOCK TABLES `ms_project_node` WRITE;
/*!40000 ALTER TABLE `ms_project_node` DISABLE KEYS */;
INSERT INTO `ms_project_node` (`id`, `node`, `title`, `is_menu`, `is_auth`, `is_login`, `create_at`) VALUES (360,'project','项目管理模块',0,1,1,1673277965322),(361,'project/index/info','详情',0,0,1,1673277965322),(362,'project/index','基础版块',0,1,1,1673277965322),(363,'project/index/index','框架布局',0,0,1,1673277965322),(364,'project/index/systemconfig','系统信息',0,0,0,1673277965322),(365,'project/index/editpersonal','修改个人资料',0,0,1,1673277965322),(366,'project/index/uploadavatar','上传头像',0,0,1,1673277965322),(370,'project/account','账号管理',0,1,1,1673277965322),(371,'project/account/index','账号列表',0,0,1,1673277965322),(372,'project/organization/index','组织列表',0,0,1,1673277965322),(373,'project/organization/save','创建组织',0,0,1,1673277965322),(374,'project/organization/read','组织信息',0,0,1,1673277965322),(375,'project/organization/edit','编辑组织',0,1,1,1673277965322),(376,'project/organization/delete','删除组织',0,1,1,1673277965322),(377,'project/organization','组织管理',0,1,1,1673277965322),(388,'project/auth/index','权限列表',0,0,1,1673277965322),(389,'project/auth/add','添加权限角色',0,1,1,1673277965322),(390,'project/auth/edit','编辑权限',0,1,1,1673277965322),(391,'project/auth/forbid','禁用权限',0,1,1,1673277965322),(392,'project/auth/resume','启用权限',0,1,1,1673277965322),(393,'project/auth/del','删除权限',0,1,1,1673277965322),(394,'project/auth','访问授权',0,1,1,1673277965322),(395,'project/auth/apply','应用权限',0,1,1,1673277965322),(396,'project/notify/index','通知列表',0,0,1,1673277965322),(397,'project/notify/noreads','未读通知',0,0,1,1673277965322),(399,'project/notify/read','通知信息',0,1,1,1673277965322),(401,'project/notify/delete','删除通知',0,1,1,1673277965322),(402,'project/notify','通知管理',0,1,1,1673277965322),(434,'project/account/auth','授权管理',0,1,1,1673277965322),(435,'project/account/add','添加账号',0,1,1,1673277965322),(436,'project/account/edit','编辑账号',0,1,1,1673277965322),(437,'project/account/del','删除账号',0,1,1,1673277965322),(438,'project/account/forbid','禁用账号',0,1,1,1673277965322),(439,'project/account/resume','启用账号',0,1,1,1673277965322),(498,'project/notify/setreadied','设置已读',0,1,1,1673277965322),(499,'project/notify/batchdel','批量删除',0,1,1,1673277965322),(500,'project/auth/setdefault','设置默认权限',0,1,1,1673277965322),(501,'project/department','部门管理',0,1,1,1673277965322),(502,'project/department/index','部门列表',0,0,1,1673277965322),(503,'project/department/read','部门信息',0,0,1,1673277965322),(504,'project/department/save','创建部门',0,1,1,1673277965322),(505,'project/department/edit','编辑部门',0,1,1,1673277965322),(506,'project/department/delete','删除部门',0,1,1,1673277965322),(507,'project/department_member','部门成员管理',0,1,1,1673277965322),(508,'project/department_member/index','部门成员列表',0,0,1,1673277965322),(509,'project/department_member/searchinvitemember','搜索部门成员',0,0,1,1673277965322),(510,'project/department_member/invitemember','添加部门成员',0,1,1,1673277965322),(511,'project/department_member/removemember','移除部门成员',0,1,1,1673277965322),(512,'project/index/changecurrentorganization','切换当前组织',0,0,1,1673277965322),(513,'project/index/editpassword','修改密码',0,1,1,1673277965322),(514,'project/index/uploadimg','上传图片',0,0,1,1673277965322),(515,'project/menu','菜单管理',0,1,1,1673277965322),(516,'project/menu/menu','菜单列表',0,0,0,1673277965322),(517,'project/menu/menuadd','添加菜单',0,1,1,1673277965322),(518,'project/menu/menuedit','编辑菜单',0,1,1,1673277965322),(519,'project/menu/menuforbid','禁用菜单',0,1,1,1673277965322),(520,'project/menu/menuresume','启用菜单',0,1,1,1673277965322),(521,'project/menu/menudel','删除菜单',0,1,1,1673277965322),(522,'project/node','节点管理',0,1,1,1673277965322),(523,'project/node/index','节点列表',0,1,1,1673277965322),(524,'project/node/alllist','全部节点列表',0,1,1,1673277965322),(525,'project/node/clear','清理节点',0,1,1,1673277965322),(526,'project/node/save','编辑节点',0,1,1,1673277965322),(527,'project/project','项目管理',0,1,1,1673277965322),(528,'project/project/index','项目列表',0,0,1,1673277965322),(529,'project/project/selflist','个人项目列表',0,0,1,1673277965322),(530,'project/project/save','创建项目',0,1,1,1673277965322),(531,'project/project/read','项目信息',0,0,1,1673277965322),(532,'project/project/edit','编辑项目',0,1,1,1673277965322),(533,'project/project/uploadcover','上传项目封面',0,0,1,1673277965322),(534,'project/project/recycle','项目放入回收站',0,1,1,1673277965322),(535,'project/project/recovery','恢复项目',0,1,1,1673277965322),(536,'project/project/archive','归档项目',0,1,1,1673277965322),(537,'project/project/recoveryarchive','取消归档项目',0,1,1,1673277965322),(538,'project/project/quit','退出项目',0,1,1,1673277965322),(539,'project/project_collect','项目收藏管理',0,0,1,1673277965322),(540,'project/project_collect/collect','收藏项目',0,1,1,1673277965322),(541,'project/project_member','项目成员管理',0,1,1,1673277965322),(542,'project/project_member/index','项目成员列表',0,0,1,1673277965322),(543,'project/project_member/searchinvitemember','搜索项目成员',0,0,1,1673277965322),(544,'project/project_member/invitemember','邀请项目成员',0,1,1,1673277965322),(545,'project/project_template','项目模板管理',0,1,1,1673277965322),(546,'project/project_template/index','项目模板列表',0,0,1,1673277965322),(547,'project/project_template/save','创建项目模板',0,1,1,1673277965322),(548,'project/project_template/uploadcover','上传项目模板封面',0,1,1,1673277965322),(549,'project/project_template/edit','编辑项目模板',0,1,1,1673277965322),(550,'project/project_template/delete','删除项目模板',0,1,1,1673277965322),(551,'project/task/index','任务列表',0,0,1,1673277965322),(552,'project/task/selflist','个人任务列表',0,0,1,1673277965322),(553,'project/task/read','任务信息',0,0,1,1673277965322),(554,'project/task/save','创建任务',0,1,1,1673277965322),(555,'project/task/taskdone','更改任务状态',0,0,1,1673277965322),(556,'project/task/assigntask','指派任务执行者',0,1,1,1673277965322),(557,'project/task/sort','任务排序',0,1,1,1673277965322),(558,'project/task/createcomment','发表任务评论',0,1,1,1673277965322),(559,'project/task/edit','编辑任务',0,1,1,1673277965322),(560,'project/task/like','点赞任务',0,0,1,1673277965322),(561,'project/task/star','收藏任务',0,0,1,1673277965322),(562,'project/task/recycle','移动任务到回收站',0,1,1,1673277965322),(563,'project/task/recovery','恢复任务',0,1,1,1673277965322),(564,'project/task/delete','删除任务',0,1,1,1673277965322),(565,'project/task','任务管理',0,1,1,1673277965322),(569,'project/task_member/index','任务成员列表',0,0,1,1673277965322),(570,'project/task_member/searchinvitemember','搜索任务成员',0,0,1,1673277965322),(571,'project/task_member/invitemember','添加任务成员',0,1,1,1673277965322),(572,'project/task_member/invitememberbatch','批量添加任务成员',0,1,1,1673277965322),(573,'project/task_member','任务成员管理',0,1,1,1673277965322),(574,'project/task_stages','任务分组管理',0,1,1,1673277965322),(575,'project/task_stages/index','任务分组列表',0,0,1,1673277965322),(576,'project/task_stages/tasks','任务分组任务列表',0,0,1,1673277965322),(577,'project/task_stages/sort','任务分组排序',0,1,1,1673277965322),(578,'project/task_stages/save','添加任务分组',0,1,1,1673277965322),(579,'project/task_stages/edit','编辑任务分组',0,1,1,1673277965322),(580,'project/task_stages/delete','删除任务分组',0,1,1,1673277965322),(581,'project/task_stages_template/index','任务分组模板列表',0,0,1,1673277965322),(582,'project/task_stages_template/save','创建任务分组模板',0,1,1,1673277965322),(583,'project/task_stages_template/edit','编辑任务分组模板',0,1,1,1673277965322),(584,'project/task_stages_template/delete','删除任务分组模板',0,1,1,1673277965322),(585,'project/task_stages_template','任务分组模板管理',0,1,1,1673277965322),(587,'project/project_member/removemember','移除项目成员',0,1,1,1673277965322),(588,'project/task/datetotalforproject','任务统计',0,0,1,1673277965322),(589,'project/task/tasksources','任务资源列表',0,0,1,1673277965322),(590,'project/file','文件管理',0,1,1,1673277965322),(591,'project/file/index','文件列表',0,0,1,1673277965322),(592,'project/file/read','文件详情',0,0,1,1673277965322),(593,'project/file/uploadfiles','上传文件',0,1,1,1673277965322),(594,'project/file/edit','编辑文件',0,1,1,1673277965322),(595,'project/file/recycle','文件移至回收站',0,1,1,1673277965322),(596,'project/file/recovery','恢复文件',0,1,1,1673277965322),(597,'project/file/delete','删除文件',0,1,1,1673277965322),(598,'project/project/getlogbyselfproject','项目概况',0,1,1,1673277965322),(599,'project/source_link','资源关联管理',0,1,1,1673277965322),(600,'project/source_link/delete','取消关联',0,1,1,1673277965322),(601,'project/task/tasklog','任务动态',0,1,1,1673277965322),(602,'project/task/recyclebatch','批量移动任务到回收站',0,1,1,1673277965322),(603,'project/invite_link','邀请链接管理',0,1,1,1673277965322),(604,'project/invite_link/save','创建邀请链接',0,1,1,1673277965322),(605,'project/task/setprivate','设置任务隐私模式',0,1,1,1673277965322),(606,'project/account/read','账号信息',0,1,1,1673277965322),(607,'project/task/batchassigntask','批量指派任务',0,1,1,1673277965322),(608,'project/task/tasktotags','任务标签',0,1,1,1673277965322),(609,'project/task/settag','设置任务标签',0,1,1,1673277965322),(610,'project/task_tag','任务标签管理',0,1,1,1673277965322),(611,'project/task_tag/index','任务标签列表',0,1,1,1673277965322),(612,'project/task_tag/save','创建任务标签',0,1,1,1673277965322),(613,'project/task_tag/edit','编辑任务标签',0,1,1,1673277965322),(614,'project/task_tag/delete','删除任务标签',0,1,1,1673277965322),(615,'project/project_features','项目版本库管理',0,1,1,1673277965322),(616,'project/project_features/index','版本库列表',0,1,1,1673277965322),(617,'project/project_features/save','添加版本库',0,1,1,1673277965322),(618,'project/project_features/edit','编辑版本库',0,1,1,1673277965322),(619,'project/project_features/delete','删除版本库',0,1,1,1673277965322),(620,'project/project_version','项目版本管理',0,1,1,1673277965322),(621,'project/project_version/index','项目版本列表',0,1,1,1673277965322),(622,'project/project_version/save','添加项目版本',0,1,1,1673277965322),(623,'project/project_version/edit','编辑项目版本',0,1,1,1673277965322),(624,'project/project_version/changestatus','更改项目版本状态',0,1,1,1673277965322),(625,'project/project_version/read','项目版本详情',0,1,1,1673277965322),(626,'project/project_version/addversiontask','关联项目版本任务',0,1,1,1673277965322),(627,'project/project_version/removeversiontask','移除项目版本任务',0,1,1,1673277965322),(628,'project/project_version/delete','删除项目版本',0,1,1,1673277965322),(629,'project/task/getlistbytasktag','标签任务列表',0,1,1,1673277965322),(630,'project/task_workflow','任务流转管理',0,1,1,1673277965322),(631,'project/task_workflow/index','任务流转列表',0,1,1,1673277965322),(632,'project/task_workflow/save','添加任务流转',0,1,1,1673277965322),(633,'project/task_workflow/edit','编辑任务流转',0,1,1,1673277965322),(634,'project/task_workflow/delete','删除任务流转',0,1,1,1673277965322),(635,'project/department_member/detail','部门成员详情',0,1,1,1673277965322),(636,'project/department_member/uploadfile','上传头像',0,1,1,1673277965322),(637,'project/task/savetaskworktime','保存任务流转',0,1,1,1673277965322),(638,'project/task/edittaskworktime','编辑任务流转',0,1,1,1673277965322),(639,'project/task/deltaskworktime','删除任务流转',0,1,1,1673277965322),(640,'project/task/uploadfile','上传文件',0,1,1,1673277965322);
/*!40000 ALTER TABLE `ms_project_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_project_template`
--

DROP TABLE IF EXISTS `ms_project_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_project_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `sort` tinyint DEFAULT '0',
  `create_time` bigint DEFAULT '0',
  `organization_code` bigint DEFAULT NULL COMMENT '组织id',
  `cover` varchar(511) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面',
  `member_code` bigint DEFAULT NULL COMMENT '创建人',
  `is_system` tinyint(1) DEFAULT '0' COMMENT '系统默认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='项目类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_project_template`
--

LOCK TABLES `ms_project_template` WRITE;
/*!40000 ALTER TABLE `ms_project_template` DISABLE KEYS */;
INSERT INTO `ms_project_template` (`id`, `name`, `description`, `sort`, `create_time`, `organization_code`, `cover`, `member_code`, `is_system`) VALUES (11,'产品进展','适用于互联网产品人员对产品计划、跟进及发布管理',0,1754969182536,14,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.51yuansu.com%2Fpic3%2Fcover%2F01%2F91%2F92%2F5982adf6c88ea_610.jpg&refer=http%3A%2F%2Fbpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673496114&t=956c5614481fedea97794e161deddb00',NULL,1),(12,'需求管理','适用于产品部门对需求的收集、评估及反馈管理',0,1754969182536,14,'https://img0.baidu.com/it/u=437485064,4277010738&fm=253&fmt=auto&app=138&f=JPEG?w=610&h=491',NULL,1),(13,'机械制造','适用于制造商对图纸设计及制造安装的工作流程管理',0,1754969182536,14,'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.51yuansu.com%2Fpic2%2Fcover%2F00%2F38%2F93%2F5812ca7a24020_610.jpg&refer=http%3A%2F%2Fbpic.51yuansu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1673496114&t=6d03fb91b230058fc43f1b7ae00f73e3',NULL,1),(19,'OKR 管理','适用于团队的 OKR 管理',0,1754969182536,14,'https://img2.baidu.com/it/u=2241642503,1613686234&fm=253&fmt=auto&app=138&f=JPEG?w=603&h=500',1007,0);
/*!40000 ALTER TABLE `ms_project_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_source_link`
--

DROP TABLE IF EXISTS `ms_source_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_source_link` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '资源类型',
  `source_code` bigint DEFAULT NULL COMMENT '资源编号',
  `link_type` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联类型',
  `link_code` bigint DEFAULT NULL COMMENT '关联编号',
  `organization_code` bigint DEFAULT NULL COMMENT '组织编码',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建时间',
  `sort` int DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='资源关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_source_link`
--

LOCK TABLES `ms_source_link` WRITE;
/*!40000 ALTER TABLE `ms_source_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `ms_source_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_task`
--

DROP TABLE IF EXISTS `ms_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_task` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_code` bigint NOT NULL DEFAULT '0' COMMENT '项目编号',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pri` tinyint unsigned DEFAULT '0' COMMENT '紧急程度',
  `execute_status` tinyint DEFAULT NULL COMMENT '执行状态',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '详情',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `done_by` bigint DEFAULT NULL COMMENT '完成人',
  `done_time` bigint DEFAULT NULL COMMENT '完成时间',
  `create_time` bigint DEFAULT NULL COMMENT '创建日期',
  `assign_to` bigint DEFAULT NULL COMMENT '指派给谁',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '回收站',
  `stage_code` int DEFAULT NULL COMMENT '任务列表',
  `task_tag` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '任务标签',
  `done` tinyint DEFAULT '0' COMMENT '是否完成',
  `begin_time` bigint DEFAULT NULL COMMENT '开始时间',
  `end_time` bigint DEFAULT NULL COMMENT '截止时间',
  `remind_time` bigint DEFAULT NULL COMMENT '提醒时间',
  `pcode` bigint DEFAULT NULL COMMENT '父任务id',
  `sort` int DEFAULT '0' COMMENT '排序',
  `like` int DEFAULT '0' COMMENT '点赞数',
  `star` int DEFAULT '0' COMMENT '收藏数',
  `deleted_time` bigint DEFAULT NULL COMMENT '删除时间',
  `private` tinyint(1) DEFAULT '0' COMMENT '是否隐私模式',
  `id_num` int DEFAULT '1' COMMENT '任务id编号',
  `path` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT '上级任务路径',
  `schedule` int DEFAULT '0' COMMENT '进度百分比',
  `version_code` bigint DEFAULT '0' COMMENT '版本id',
  `features_code` bigint DEFAULT '0' COMMENT '版本库id',
  `work_time` int DEFAULT '0' COMMENT '预估工时',
  `status` tinyint DEFAULT '0' COMMENT '执行状态。0：未开始，1：已完成，2：进行中，3：挂起，4：测试中',
  PRIMARY KEY (`id`,`project_code`) USING BTREE,
  KEY `stage_code` (`stage_code`) USING BTREE,
  KEY `project_code` (`project_code`) USING BTREE,
  KEY `pcode` (`pcode`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12381 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_task`
--

LOCK TABLES `ms_task` WRITE;
/*!40000 ALTER TABLE `ms_task` DISABLE KEYS */;
INSERT INTO `ms_task` (`id`, `project_code`, `name`, `pri`, `execute_status`, `description`, `create_by`, `done_by`, `done_time`, `create_time`, `assign_to`, `deleted`, `stage_code`, `task_tag`, `done`, `begin_time`, `end_time`, `remind_time`, `pcode`, `sort`, `like`, `star`, `deleted_time`, `private`, `id_num`, `path`, `schedule`, `version_code`, `features_code`, `work_time`, `status`) VALUES (1,13043,'测试1',0,NULL,NULL,1007,NULL,NULL,NULL,1007,0,100,NULL,0,NULL,NULL,NULL,NULL,65536,0,0,NULL,1,1,NULL,0,0,0,0,0),(12363,13043,'测试2',0,NULL,NULL,1007,NULL,NULL,NULL,1006,0,99,NULL,0,NULL,NULL,NULL,NULL,32768,0,0,NULL,0,1,NULL,0,0,0,0,0),(12372,13048,'111',0,0,'',1007,0,0,1755336261870,1007,0,78,'',0,1755336261870,1755509061870,0,0,35840,0,0,0,0,1,'',0,0,0,0,0),(12373,13048,'222',0,0,'',1007,0,0,1755336263538,1007,0,78,'',0,1755336263538,1755509063538,0,0,17920,0,0,0,0,2,'',0,0,0,0,0),(12374,13048,'333',0,0,'',1007,0,0,1755336265341,1007,0,78,'',0,1755336265341,1755509065341,0,0,68608,0,0,0,0,3,'',0,0,0,0,0),(12375,13048,'444',0,0,'',1007,0,0,1755336267827,1007,0,79,'',0,1755336267827,1755509067827,0,0,65536,0,0,0,0,4,'',0,0,0,0,0),(12376,13048,'555',0,0,'',1007,0,0,1755336269142,1007,0,80,'',0,1755336269142,1755509069142,0,0,65536,0,0,0,0,5,'',0,0,0,0,0),(12377,13048,'666',0,0,'',1007,0,0,1755490265302,1007,0,81,'',0,1755490265302,1755663065302,0,0,65536,0,0,0,0,6,'',0,0,0,0,0),(12378,13051,'文件1',0,0,'',1007,0,0,1755513020709,1007,0,101,'',0,1755513020709,1755685820709,0,0,122880,0,0,0,0,1,'',0,0,0,0,0),(12379,13051,'文件2',0,0,'',1007,0,0,1755513023210,1007,0,101,'',0,1755513023210,1755685823210,0,0,131072,0,0,0,0,2,'',0,0,0,0,0),(12380,13051,'文件3',0,0,'',1007,0,0,1755589718797,1007,0,101,'',0,1755589718797,1755762518797,0,0,196608,0,0,0,0,3,'',0,0,0,0,0);
/*!40000 ALTER TABLE `ms_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_task_member`
--

DROP TABLE IF EXISTS `ms_task_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_task_member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_code` bigint DEFAULT '0' COMMENT '任务ID',
  `is_executor` tinyint(1) DEFAULT '0' COMMENT '执行者',
  `member_code` bigint DEFAULT NULL COMMENT '成员id',
  `join_time` bigint DEFAULT NULL,
  `is_owner` tinyint(1) DEFAULT '0' COMMENT '是否创建人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=290 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务-成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_task_member`
--

LOCK TABLES `ms_task_member` WRITE;
/*!40000 ALTER TABLE `ms_task_member` DISABLE KEYS */;
INSERT INTO `ms_task_member` (`id`, `task_code`, `is_executor`, `member_code`, `join_time`, `is_owner`) VALUES (1,1,1,1007,NULL,1),(2,1,1,1006,NULL,0),(273,12364,1,1007,1755314836537,1),(274,12365,1,1007,1755314877787,1),(275,12366,1,1007,1755314976641,1),(276,12367,1,1007,1755330529537,1),(277,12368,1,1007,1755330537746,1),(278,12369,1,1007,1755336196843,1),(279,12370,1,1007,1755336198672,1),(280,12371,1,1007,1755336199956,1),(281,12372,1,1007,1755336261877,1),(282,12373,1,1007,1755336263545,1),(283,12374,1,1007,1755336265349,1),(284,12375,1,1007,1755336267834,1),(285,12376,1,1007,1755336269149,1),(286,12377,1,1007,1755490265318,1),(287,12378,1,1007,1755513020714,1),(288,12379,1,1007,1755513023214,1),(289,12380,1,1007,1755589718806,1);
/*!40000 ALTER TABLE `ms_task_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_task_stages`
--

DROP TABLE IF EXISTS `ms_task_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_task_stages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型名称',
  `project_code` bigint DEFAULT NULL COMMENT '项目id',
  `sort` int DEFAULT '0' COMMENT '排序',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `create_time` bigint DEFAULT NULL COMMENT '创建时间',
  `deleted` tinyint(1) DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='任务列表表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_task_stages`
--

LOCK TABLES `ms_task_stages` WRITE;
/*!40000 ALTER TABLE `ms_task_stages` DISABLE KEYS */;
INSERT INTO `ms_task_stages` (`id`, `name`, `project_code`, `sort`, `description`, `create_time`, `deleted`) VALUES (78,'需求收集',13048,1,'',1755225809573,0),(79,'评估确认',13048,2,'',1755225809579,0),(80,'需求暂缓',13048,3,'',1755225809581,0),(81,'研发中',13048,4,'',1755225809585,0),(82,'内测中',13048,5,'',1755225809587,0),(83,'通知用户',13048,6,'',1755225809589,0),(84,'已完成&归档',13048,7,'',1755225809591,0),(99,'测试1',13043,0,NULL,NULL,0),(100,'222',13043,0,NULL,NULL,0),(101,'产品计划',13051,1,'',1755513014022,0),(102,'即将发布',13051,2,'',1755513014025,0),(103,'测试',13051,3,'',1755513014028,0),(104,'准备发布',13051,4,'',1755513014030,0),(105,'发布成功',13051,5,'',1755513014033,0);
/*!40000 ALTER TABLE `ms_task_stages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_task_stages_template`
--

DROP TABLE IF EXISTS `ms_task_stages_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_task_stages_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型名称',
  `project_template_code` int DEFAULT '0' COMMENT '项目id',
  `create_time` bigint DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=COMPACT COMMENT='任务列表模板表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_task_stages_template`
--

LOCK TABLES `ms_task_stages_template` WRITE;
/*!40000 ALTER TABLE `ms_task_stages_template` DISABLE KEYS */;
INSERT INTO `ms_task_stages_template` (`id`, `name`, `project_template_code`, `create_time`, `sort`) VALUES (61,'待处理',19,1670904236057,1),(62,'进行中',19,1670904236057,0),(63,'已完成',19,1670904236057,0),(65,'协议签订',13,1670904236057,0),(66,'图纸设计',13,1670904236057,0),(67,'评审及打样',13,1670904236057,0),(68,'构件采购',13,1670904236057,0),(69,'制造安装',13,1670904236057,0),(70,'内部检验',13,1670904236057,0),(71,'验收',13,1670904236057,0),(72,'需求收集',12,1670904236057,0),(73,'评估确认',12,1670904236057,0),(74,'需求暂缓',12,1670904236057,0),(75,'研发中',12,1670904236057,0),(76,'内测中',12,1670904236057,0),(77,'通知用户',12,1670904236057,0),(78,'已完成&归档',12,1670904236057,0),(79,'产品计划',11,1670904236057,0),(80,'即将发布',11,1670904236057,0),(81,'测试',11,1670904236057,0),(82,'准备发布',11,1670904236057,0),(83,'发布成功',11,1670904236057,0);
/*!40000 ALTER TABLE `ms_task_stages_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ms_task_work_time`
--

DROP TABLE IF EXISTS `ms_task_work_time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ms_task_work_time` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_code` bigint DEFAULT '0' COMMENT '任务ID',
  `member_code` bigint DEFAULT NULL COMMENT '成员id',
  `create_time` bigint DEFAULT NULL,
  `content` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '描述',
  `begin_time` bigint DEFAULT NULL COMMENT '开始时间',
  `num` int DEFAULT '0' COMMENT '工时',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='任务工时表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ms_task_work_time`
--

LOCK TABLES `ms_task_work_time` WRITE;
/*!40000 ALTER TABLE `ms_task_work_time` DISABLE KEYS */;
INSERT INTO `ms_task_work_time` (`id`, `task_code`, `member_code`, `create_time`, `content`, `begin_time`, `num`) VALUES (1,12377,1007,0,'睡觉',1755531600000,12),(5,12377,1007,0,'test',1755532560000,2),(6,12380,1007,0,'2',1755618480000,1),(7,12380,1007,0,'12',1755618900000,2);
/*!40000 ALTER TABLE `ms_task_work_time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'msproject'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-26 11:33:09
