#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test test/fixtures/pass/job.yml
	assert_success
}

@test "JOB-01 - backoffLimit set" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.backoffLimit'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'JOB-01'
}
