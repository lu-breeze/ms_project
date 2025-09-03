package model

import (
	"go_project/ms_project/project_common/errs"
)

var (
	RedisError            = errs.NewError(999, "redis操作失败")
	DBError               = errs.NewError(998, "数据库操作失败")
	ParamsError           = errs.NewError(401, "参数错误")
	NoLegalMobile         = errs.NewError(10102001, "手机号格式不正确")
	CaptchaNotExist       = errs.NewError(10102002, "验证码不存在或已过期")
	CaptchaError          = errs.NewError(10102003, "验证码错误")
	EmailExist            = errs.NewError(10102004, "邮箱已存在")
	AccountExist          = errs.NewError(10102005, "账号已存在")
	MobileExist           = errs.NewError(10102006, "手机号已存在")
	AccountOrPwdError     = errs.NewError(10102007, "账号或密码错误")
	TaskNameNotNull       = errs.NewError(20102001, "任务名称不能为空")
	TaskStagesNotNull     = errs.NewError(20102002, "任务阶段不能为空")
	ProjectAlreadyDeleted = errs.NewError(20102003, "项目已被删除或不存在")
)
