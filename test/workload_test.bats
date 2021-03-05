#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test test/fixtures/pass/deployment.yml test/fixtures/pass/job.yml
	assert_success
}

@test "WRK-01 - Deployment containers set resource requests" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].resources.requests'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-01'
}

@test "WRK-01 - Deployment containers set resource limits" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].resources.limits'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-01'
}

@test "WRK-01 - Job containers set resource requests" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.spec.containers[0].resources.requests'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-01'
}

@test "WRK-01 - Job containers set resource limits" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.spec.containers[0].resources.limits'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-01'
}

@test "WRK-01 - CronJob containers set resource requests" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.spec.containers[0].resources.requests'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-01'
}

@test "WRK-01 - CronJob containers set resource limits" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.spec.containers[0].resources.limits'

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-01'
}

@test "WRK-02 - Deployment containers volume mount" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].volumeMounts[0].name' junk

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-02'
}

@test "WRK-02 - Job containers volume mount" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.spec.containers[0].volumeMounts[0].name' junk

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-02'
}

@test "WRK-02 - CronJob containers volume mount" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.spec.containers[0].volumeMounts[0].name' junk

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-02'
}

@test "WRK-03 - Deployment unmounted volume" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.volumes[+].name' junk

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-03'
}

@test "WRK-03 - Job unmounted volume" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.spec.volumes[+].name' junk

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-03'
}

@test "WRK-03 - CronJob unmounted volume" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.spec.volumes[+].name' junk

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-03'
}

@test "WRK-03 - Deployments without volumes" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.volumes'
	yq d -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].volumeMounts'

	run conftest test "${fixture}/"*
	assert_success
}

@test "WRK-03 - Jobs without volumes" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.spec.volumes'
	yq d -i "${fixture}/job.yml" 'spec.template.spec.containers[0].volumeMounts'

	run conftest test "${fixture}/"*
	assert_success
}

@test "WRK-03 - CronJob without volumes" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq d -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.spec.volumes'
	yq d -i "${fixture}/cron_job.yml" 'spec.joTemplate.spec.template.spec.containers[0].volumeMounts'

	run conftest test "${fixture}/"*
	assert_success
}

@test "WRK-04 - Deployment containers invalid image" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.spec.containers[0].image' 'FOO'

	run conftest test "${fixture}/"*
	assert_failure
	assert_denied 'WRK-04'
}

@test "WRK-04 - Job containers invalid image" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.spec.containers[0].image' 'FOO'

	run conftest test "${fixture}/"*
	assert_failure
	assert_denied 'WRK-04'
}

@test "WRK-04 - CronJob containers invalid image" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.spec.containers[0].image' 'FOO'

	run conftest test "${fixture}/"*
	assert_failure
	assert_denied 'WRK-04'
}

@test "WRK-05 - Deployment containers env var value type" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_env_var.yml \
		"${fixture}/deployment.yml"

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-05'
}

@test "WRK-05 - Job containers env var value type" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_env_var.yml \
		"${fixture}/job.yml"

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-05'
}

@test "WRK-05 - CronJob containers env var value type" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/pass/ "${fixture}"

	yq w -i -s \
		test/script/insert_invalid_cron_job_env_var.yml \
		"${fixture}/cron_job.yml"

	run conftest test "${fixture}/"*
	assert_failure

	assert_denied 'WRK-05'
}
