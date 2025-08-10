package jwts

import "testing"

func TestParseToken(t *testing.T) {
	tokenString := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTUyNDQxNTMsInRva2VuIjoiMTAwNiJ9.SSBtcbA8iadpy6gSOB6pugQhHKjkrXq-H9YlApzgtEw"
	ParseToken(tokenString, "msproject")
}
