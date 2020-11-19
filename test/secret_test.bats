#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load

setup() {
	run conftest test test/fixtures/pass/secret.yml
	assert_success
}

@test "SEC-01 - Valid Base64 values" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/secret.yml" 'stringData'
	yq w -i "${fixture}/secret.yml" 'data.FOO' '@#*$&@#$&#@'

	run conftest test "${fixture}/"*
	assert_failure

	assert_output --partial 'SEC-01'
}
