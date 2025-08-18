package tms

import (
	"time"
)

// 将时间戳转化为易读的时间格式
func Format(t time.Time) string {
	return t.Format("2006-01-02 15:04:05")
}
func FormatYMD(t time.Time) string {
	loc, _ := time.LoadLocation("Asia/Shanghai")
	return t.In(loc).Format("2006-01-02")
}
func FormatByMill(t int64) string {
	t = t - 8*3600*1000 // UTO减去8小时的毫秒数，转换为北京时间
	return time.UnixMilli(t).Format("2006-01-02 15:04:05")
}
func ParseTime(str string) int64 {
	parse, _ := time.Parse("2006-01-02 15:04", str)
	return parse.UnixMilli()
}
