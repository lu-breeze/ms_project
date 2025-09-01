package data

type ProjectAuthNode struct {
	Id   int64
	Auth int64
	Node string
}

func (p *ProjectAuthNode) TableName() string {
	return "ms_project_auth_node"
}
