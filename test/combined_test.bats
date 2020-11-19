#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test \
		--combine --namespace combined test/fixtures/pass/*
	assert_success
}

@test "CMB-01 - Deployment container ConfigMap" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_reference.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-01'
}

@test "CMB-01 - Deployment container Secret" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_reference.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-01'
}

@test "CMB-01 - Job container ConfigMap" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_reference.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-01'
}

@test "CMB-01 - Job container envFrom Secret" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_reference.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-01'
}

@test "CMB-02 - Deployment volume from ConfigMap" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_volume.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-02'
}

@test "CMB-02 - Deployment volume from Secret" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_volume.yml \
		"${fixture}/deployment.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-02'
}

@test "CMB-02 - Job volume from ConfigMap" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_configmap_volume.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-02'
}

@test "CMB-02 - Job volume from Secret" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_secret_volume.yml \
		"${fixture}/job.yml"

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-02'
}

@test "CMB-03 - Service selector matches Deployment labels" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/service.yml" 'spec.selector.app' junk

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-03'
}

@test "CMB-04 - HPA scale target matches Deployment" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/horizontal_pod_autoscaler.yml" 'spec.scaleTargetRef.name' junk

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-04'
}

@test "CMB-05 - Service port matches numbered container port" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/service.yml" 'spec.ports[0].targetPort' 9999

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-05'
}

@test "CMB-05 - Service port matches named container port" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/service.yml" 'spec.ports[0].targetPort' http
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' http

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_success

	yq w -i "${fixture}/service.yml" 'spec.ports[0].targetPort' http
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' junk

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-05'

	yq w -i "${fixture}/service.yml" 'spec.ports[0].targetPort' junk
	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].ports[0].name' http

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-05'
}

@test "CMB-06 - HPA Deployment replicas" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.replicas' 3

	run conftest test \
		--combine --namespace combined \
		"${fixture}/"*
	assert_failure

	assert_denied 'CMB-06'
}
