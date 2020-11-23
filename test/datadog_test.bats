#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test --namespace datadog test/fixtures/pass/*
	assert_success
}

#############################################################
#                                                           #
#                       DOG-01                              #
#                                                           #
#############################################################

@test "DOG-01 - Deployment missing tags" {
	tags=(env service version)

	for tag in "${tags[@]}"; do
		yq d test/fixtures/pass/deployment.yml \
			"metadata.labels.\"tags.datadoghq.com/${tag}\"" > "${BATS_TMPDIR}/deployment.yml"

		run conftest test --namespace datadog "${BATS_TMPDIR}/deployment.yml"
		assert_failure
		assert_denied 'DOG-01'

		yq d test/fixtures/pass/deployment.yml \
			"spec.template.metadata.labels.\"tags.datadoghq.com/${tag}\"" > "${BATS_TMPDIR}/deployment.yml"
		run conftest test --namespace datadog "${BATS_TMPDIR}/deployment.yml"
		assert_failure
		assert_denied 'DOG-01'

		yq d test/fixtures/pass/deployment.yml \
			"spec.template.spec.containers[0].env" > "${BATS_TMPDIR}/deployment.yml"
		run conftest test --namespace datadog "${BATS_TMPDIR}/deployment.yml"
		assert_failure
		assert_denied 'DOG-01'
	done
}

@test "DOG-01 - Job missing tags" {
	tags=(env service version)

	for tag in "${tags[@]}"; do
		yq d test/fixtures/pass/job.yml \
			"metadata.labels.\"tags.datadoghq.com/${tag}\"" > "${BATS_TMPDIR}/job.yml"

		run conftest test --namespace datadog "${BATS_TMPDIR}/job.yml"
		assert_failure
		assert_denied 'DOG-01'

		yq d test/fixtures/pass/job.yml \
			"spec.template.metadata.labels.\"tags.datadoghq.com/${tag}\"" > "${BATS_TMPDIR}/job.yml"
		run conftest test --namespace datadog "${BATS_TMPDIR}/job.yml"
		assert_failure
		assert_denied 'DOG-01'

		yq d test/fixtures/pass/deployment.yml \
			"spec.template.spec.containers[0].env" > "${BATS_TMPDIR}/job.yml"
		run conftest test --namespace datadog "${BATS_TMPDIR}/job.yml"
		assert_failure
		assert_denied 'DOG-01'
	done
}

@test "DOG-01 - CronJob missing tags" {
	tags=(env service version)

	for tag in "${tags[@]}"; do
		yq d test/fixtures/pass/cron_job.yml \
			"metadata.labels.\"tags.datadoghq.com/${tag}\"" > "${BATS_TMPDIR}/cron_job.yml"

		run conftest test --namespace datadog "${BATS_TMPDIR}/cron_job.yml"
		assert_failure
		assert_denied 'DOG-01'

		yq d test/fixtures/pass/cron_job.yml \
			"spec.jobTemplate.spec.template.metadata.labels.\"tags.datadoghq.com/${tag}\"" > "${BATS_TMPDIR}/cron_job.yml"
		run conftest test --namespace datadog "${BATS_TMPDIR}/cron_job.yml"
		assert_failure
		assert_denied 'DOG-01'

		yq d test/fixtures/pass/cron_job.yml \
			"spec.jobTemplate.spec.template.spec.containers[0].env" > "${BATS_TMPDIR}/cron_job.yml"
		run conftest test --namespace datadog "${BATS_TMPDIR}/cron_job.yml"
		assert_failure
		assert_denied 'DOG-01'
	done
}

@test "DOG-01 - Deployment invalid env" {
	yq w test/fixtures/pass/deployment.yml \
		'metadata.labels."tags.datadoghq.com/env"' 'junk' > "${BATS_TMPDIR}/deployment.yml"

	run conftest test --namespace datadog "${BATS_TMPDIR}/deployment.yml"
	assert_failure
	assert_denied 'DOG-01'

	yq w test/fixtures/pass/deployment.yml \
		'spec.template.metadata.labels."tags.datadoghq.com/env"' 'junk' > "${BATS_TMPDIR}/deployment.yml"
	run conftest test --namespace datadog "${BATS_TMPDIR}/deployment.yml"
	assert_failure
	assert_denied 'DOG-01'
}

@test "DOG-01 - Job invalid env" {
	yq w test/fixtures/pass/job.yml \
		'metadata.labels."tags.datadoghq.com/env"' 'junk' > "${BATS_TMPDIR}/job.yml"

	run conftest test --namespace datadog "${BATS_TMPDIR}/job.yml"
	assert_failure
	assert_denied 'DOG-01'

	yq w test/fixtures/pass/job.yml \
		'spec.template.metadata.labels."tags.datadoghq.com/env"' 'junk' > "${BATS_TMPDIR}/job.yml"
	run conftest test --namespace datadog "${BATS_TMPDIR}/job.yml"
	assert_failure
	assert_denied 'DOG-01'
}

@test "DOG-01 - CronJob invalid env" {
	yq w test/fixtures/pass/cron_job.yml \
		'metadata.labels."tags.datadoghq.com/env"' 'junk' > "${BATS_TMPDIR}/cron_job.yml"

	run conftest test --namespace datadog "${BATS_TMPDIR}/cron_job.yml"
	assert_failure
	assert_denied 'DOG-01'

	yq w test/fixtures/pass/cron_job.yml \
		'spec.jobTemplate.spec.template.metadata.labels."tags.datadoghq.com/env"' 'junk' > "${BATS_TMPDIR}/cron_job.yml"
	run conftest test --namespace datadog "${BATS_TMPDIR}/cron_job.yml"
	assert_failure
	assert_denied 'DOG-01'
}

#############################################################
#                                                           #
#                       DOG-02                              #
#                                                           #
#############################################################

@test "DOG-02 - Deployment missing DD_AGENT_HOST" {
	yq d test/fixtures/pass/deployment.yml \
		"spec.template.spec.containers[0].env" > "${BATS_TMPDIR}/deployment.yml"
	run conftest test --namespace datadog "${BATS_TMPDIR}/deployment.yml"
	assert_failure
	assert_denied 'DOG-02'
}

@test "DOG-02 - Job missing DD_AGENT_HOST" {
	yq d test/fixtures/pass/deployment.yml \
		"spec.template.spec.containers[0].env" > "${BATS_TMPDIR}/job.yml"
	run conftest test --namespace datadog "${BATS_TMPDIR}/job.yml"
	assert_failure
	assert_denied 'DOG-02'
}

@test "DOG-02 - CronJob missing DD_AGENT_HOST" {
	yq d test/fixtures/pass/cron_job.yml \
		"spec.jobTemplate.spec.template.spec.containers[0].env" > "${BATS_TMPDIR}/cron_job.yml"
	run conftest test --namespace datadog "${BATS_TMPDIR}/cron_job.yml"
	assert_failure
	assert_denied 'DOG-02'
}
