#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test test/fixtures/pass/config_map.yml
	assert_success
}

@test "CFG-01 - Value type" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/config_map.yml" 'data.FOO' 'true'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'CFG-01'
}
