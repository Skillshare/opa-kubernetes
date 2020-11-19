#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load

setup() {
	run conftest test test/fixtures/pass/horizontal_pod_autoscaler.yml
	assert_success
}

@test "HPA-01 - HPA replica sanity" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/horizontal_pod_autoscaler.yml" 'spec.minReplicas' 10
	yq w -i "${fixture}/horizontal_pod_autoscaler.yml" 'spec.maxReplicas' 1

	run conftest test "${fixture}/"*
	assert_failure

	assert_output --partial 'HPA-01'
}
