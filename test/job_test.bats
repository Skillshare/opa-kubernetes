#!/usr/bin/env basts

setup() {
	run conftest test test/fixtures/pass/job.yml
	[ $status -eq 0 ]
}

@test "JOB-01 - backoffLimit set" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.backoffLimit'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'JOB-01'
}
