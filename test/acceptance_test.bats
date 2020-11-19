#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load

@test "Valid data passes main package" {
	run conftest test \
		test/fixtures/pass/*
	assert_success
}

@test "Valid data passes combined package" {
	run conftest test \
		--combine --namespace combined \
		test/fixtures/pass/*
	assert_success
}
