#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test -n staging test/fixtures/pass/*
	assert_success
}

@test "STG-01 - apps ingress missing whitelist" {
	yq d \
		"test/fixtures/pass/ingress.yml" \
		'metadata.annotations."nginx.ingress.kubernetes.io/whitelist-source-range"' \
		> "${BATS_TMPDIR}/ingress.yml"

	run conftest test -n staging "${BATS_TMPDIR}/ingress.yml"
	assert_failure

	assert_denied 'STG-01'
}

@test "STG-01 - apps ingress missing whitelist Eng VPN whitelist" {
	yq w \
		"test/fixtures/pass/ingress.yml" \
		'metadata.annotations."nginx.ingress.kubernetes.io/whitelist-source-range"' \
		'34.196.181.12/32' \
		> "${BATS_TMPDIR}/ingress.yml"

	run conftest test -n staging "${BATS_TMPDIR}/ingress.yml"
	assert_failure

	assert_denied 'STG-01'
}

@test "STG-01 - apps ingress missing whitelist Ops VPN whitelist" {
	yq w \
		"test/fixtures/pass/ingress.yml" \
		'metadata.annotations."nginx.ingress.kubernetes.io/whitelist-source-range"' \
		'35.175.17.80/32' \
		> "${BATS_TMPDIR}/ingress.yml"

	run conftest test -n staging "${BATS_TMPDIR}/ingress.yml"
	assert_failure

	assert_denied 'STG-01'
}
