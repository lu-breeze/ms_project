package data

import (
	"github.com/jinzhu/copier"
	"go_project/ms_project/project_common/encrypts"
	"go_project/ms_project/project_common/tms"
)

type TaskWorkTime struct {
	Id         int64
	TaskCode   int64
	MemberCode int64
	CreateTime int64
	Content    string
	BeginTime  int64
	Num        int
}

func (*TaskWorkTime) TableName() string {
	return "ms_task_work_time"
}

type TaskWorkTimeDisplay struct {
	Id         int64
	TaskCode   string
	MemberCode string
	CreateTime string
	Content    string
	BeginTime  string
	Num        int
	Member     Member
}

func (t *TaskWorkTime) ToDisplay() *TaskWorkTimeDisplay {
	td := &TaskWorkTimeDisplay{}
	copier.Copy(td, t)
	td.MemberCode = encrypts.EncryptNoErr(t.MemberCode)
	td.TaskCode = encrypts.EncryptNoErr(t.TaskCode)
	td.CreateTime = tms.FormatByMillConvert(t.CreateTime)
	td.BeginTime = tms.FormatByMillConvert(t.BeginTime)
	return td
}
