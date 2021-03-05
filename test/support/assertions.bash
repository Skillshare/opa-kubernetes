assert_denied() {
	assert [ $# -eq 1 ]
	assert_output --partial "${1}"
}

assert_warn() {
	assert [ $# -eq 1 ]
	assert_output --partial 'WARN'
	assert_output --partial "${1}"
}
