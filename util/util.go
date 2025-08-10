package util

import (
	"fmt"
	"os/exec"
	"strings"
)

func GetWslIP() string {
	cmd := exec.Command("wsl", "hostname", "-I")
	out, err := cmd.Output()
	if err != nil {
		return "127.0.0.1" // 回退方案
	}
	ips := strings.TrimSpace(string(out))
	fmt.Println(strings.Split(ips, " ")[0])
	return strings.Split(ips, " ")[0] // 取第一个IP
}
