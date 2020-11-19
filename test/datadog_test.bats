#!/usr/bin/env basts

load vendor/bats-support/load
load vendor/bats-assert/load
load support/assertions

setup() {
	run conftest test --namespace datadog -d test/fixtures/data test/fixtures/datadog/*
	assert_success
}

#############################################################
#                                                           #
#                       DOG-01                              #
#                                                           #
#############################################################

@test "DOG-01 - Deployment missing tags annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/tags"'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - Deployment empty tag annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/tags"', '{}'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - Deployment missing annotations" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - Job missing tags annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/tags"'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - Job empty tag annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/tags"', '{}'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - Job missing annotations" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.metadata.annotations'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - CronJob missing tags annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/tags"'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - CronJob empty tag annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/tags"', '{}'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

@test "DOG-01 - CronJob missing annotations" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations'

	run conftest test --namespace datadog -d test/fixtures/data "${fixture}/"*
	assert_failure

	assert_denied 'DOG-01'
}

#############################################################
#                                                           #
#                       DOG-02                              #
#                                                           #
#############################################################

@test "DOG-02 - Deployment missing container log annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Deployment log annotation incorrect source" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "source": "junk", "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Deployment log annotation missing source" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Deployment log annotation missing service" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "source": "docker" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Deployment unmapped log annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/deployment.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/junk.logs"' '[{ "source": "docker", "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Job missing container log annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Job log annotation incorrect source" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "source": "junk", "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Job log annotation missing source" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Job log annotation missing service" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "source": "docker" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - Job unmapped log annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/job.yml" 'spec.template.metadata.annotations."ad.datadoghq.com/junk.logs"' '[{ "source": "docker", "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - CronJob missing container log annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq d -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - CronJob log annotation incorrect source" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "source": "junk", "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - CronJob log annotation missing source" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - CronJob log annotation missing service" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/dummy.logs"' '[{ "source": "docker" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}

@test "DOG-02 - CronJob unmapped log annotation" {
	fixture="$(mktemp -d)"
	rsync -r test/fixtures/datadog/ "${fixture}"

	yq w -i "${fixture}/cron_job.yml" 'spec.jobTemplate.spec.template.metadata.annotations."ad.datadoghq.com/junk.logs"' '[{ "source": "docker", "service": "foo" }]'

	run conftest test --namespace datadog "${fixture}/"*
	assert_failure

	assert_denied 'DOG-02'
}
