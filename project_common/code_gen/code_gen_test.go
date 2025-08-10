package code_gen

import "testing"

func TestGenStruct(t *testing.T) {
	GenProtoMessage("ms_project", "ProjectMessage")
}
