#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test \
		--combine --namespace combined test/fixtures/pass/*
	assert_success
}

@test "MTA-01 - namespace" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'metadata.namespace' 'foo'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-01'
}

@test "MTA-02 - deployment labels" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'metadata.labels'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-02'
}

@test "MTA-03 - name length" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" \
		'metadata.name' \
		"$(head -c 100 /dev/zero | tr '\0' 'X')"

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'
}

@test "MTA-03 - name validation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	# disallowed $ character
	yq w -i "${fixture}/deployment.yml" 'metadata.name' '$FOO'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'

	# disallowed {{ }} character
	yq w -i "${fixture}/deployment.yml" 'metadata.name' '{{FOO}}'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'

	# cannot start with -
	yq w -i "${fixture}/deployment.yml" 'metadata.name' -- '-foo'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'

	# cannot start with _
	yq w -i "${fixture}/deployment.yml" 'metadata.name' '_foo'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'

	# cannot end with -
	yq w -i "${fixture}/deployment.yml" 'metadata.name' 'foo-'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'

	# cannot end with .
	yq w -i "${fixture}/deployment.yml" 'metadata.name' 'foo.'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'

	# cannot end with _
	yq w -i "${fixture}/deployment.yml" 'metadata.name' 'foo_'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'MTA-03'
}
