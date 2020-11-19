assert_denied() {
	assert [ $# -eq 1 ]
	assert_output --partial "${1}"
}
