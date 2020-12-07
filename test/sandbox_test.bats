#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test -n sandbox test/fixtures/pass/*
	assert_success
}

@test "SBX-01 - apps ingress missing whitelist" {
	yq d \
		"test/fixtures/pass/ingress.yml" \
		'metadata.annotations."nginx.ingress.kubernetes.io/whitelist-source-range"' \
		> "${BATS_TMPDIR}/ingress.yml"

	run conftest test -n sandbox "${BATS_TMPDIR}/ingress.yml"
	assert_failure

	assert_denied 'SBX-01'
}

@test "SBX-01 - apps ingress missing whitelist Eng VPN whitelist" {
	yq w \
		"test/fixtures/pass/ingress.yml" \
		'metadata.annotations."nginx.ingress.kubernetes.io/whitelist-source-range"' \
		'34.196.181.12/32' \
		> "${BATS_TMPDIR}/ingress.yml"

	run conftest test -n sandbox "${BATS_TMPDIR}/ingress.yml"
	assert_failure

	assert_denied 'SBX-01'
}

@test "SBX-01 - apps ingress missing whitelist Ops VPN whitelist" {
	yq w \
		"test/fixtures/pass/ingress.yml" \
		'metadata.annotations."nginx.ingress.kubernetes.io/whitelist-source-range"' \
		'35.175.17.80/32' \
		> "${BATS_TMPDIR}/ingress.yml"

	run conftest test -n sandbox "${BATS_TMPDIR}/ingress.yml"
	assert_failure

	assert_denied 'SBX-01'
}

@test "SBX-02 - HPA replicas" {
	yq w \
		"test/fixtures/pass/horizontal_pod_autoscaler.yml" \
		'spec.maxReplicas'	20 \
		> "${BATS_TMPDIR}/hpa.yml"

	run conftest test -n sandbox "${BATS_TMPDIR}/hpa.yml"
	assert_failure
	assert_denied 'SBX-02'
}
