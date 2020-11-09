#!/usr/bin/env basts

setup() {
	run conftest test test/fixtures/pass/deployment.yml
	[ $status -eq 0 ]
}

@test "DPL-01 - containers set liveness probes" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-01'
}

@test "DPL-01 - containers set readiness probes" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-01'
}

@test "DPL-02 - selector matches template labels" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.selector.matchLabels.extra' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-02'
}

@test "DPL-02 - empty label selector" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.selector.matchLabels.app'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-02'
}

@test "DPL-02 - template labels missing" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.metadata.labels'

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-02'
}

@test "DPL-03 - containers mismatched HTTP liveness probe port number" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.httpGet.port' 9999

	cat "${fixture}/deployment.yml"

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched HTTP liveness probe port name" {
	fixture="$(mktemp -d)"

	rsync -r test/fixtures/pass/ "${fixture}"
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.httpGet.port' http
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' http

	run conftest test "${fixture}/"*
	[ $status -eq 0 ]

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.httpGet.port' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched TCP liveness probe port number" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.tcpSocket.port' 9999
	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.httpGet' 9999

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched TCP liveness probe port name" {
	fixture="$(mktemp -d)"

	rsync -r test/fixtures/pass/ "${fixture}"
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.tcpSocket.port' tcp
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' tcp

	run conftest test "${fixture}/"*
	[ $status -eq 0 ]

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].livenessProbe.tcpSocket.port' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched HTTP readiness probe port number" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.httpGet.port' 9999

	cat "${fixture}/deployment.yml"

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched HTTP readiness probe port name" {
	fixture="$(mktemp -d)"

	rsync -r test/fixtures/pass/ "${fixture}"
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.httpGet.port' http
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' http

	run conftest test "${fixture}/"*
	[ $status -eq 0 ]

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.httpGet.port' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched TCP readiness probe port number" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.tcpSocket.port' 9999
	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.httpGet' 9999

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}

@test "DPL-03 - containers mismatched TCP readiness probe port name" {
	fixture="$(mktemp -d)"

	rsync -r test/fixtures/pass/ "${fixture}"
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.tcpSocket.port' tcp
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' tcp

	run conftest test "${fixture}/"*
	[ $status -eq 0 ]

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].readinessProbe.tcpSocket.port' junk

	run conftest test "${fixture}/"*
	[ $status -ne 0 ]

	echo "${output[@]}" | grep -qF 'DPL-03'
}
