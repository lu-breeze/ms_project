package fs

import "os"

func IsExist(path string) bool {
	//获取路径文件信息
	_, err := os.Stat(path)
	if err != nil {
		if os.IsNotExist(err) {
			return false
		}
		return true
	}
	return true
}
