package datadog

import data.kubernetes

universal_tags := ["env", "service", "version"]

allowed_envs := {"sandbox", "staging", "prod"}

name = input.metadata.name

container_env_var(container, tag) {
	env_var := sprintf("DD_%s", [upper(tag)])
	label := sprintf("tags.datadoghq.com/%s", [tag])
	field_path = sprintf("metadata.labels['%s']", [label])

	environment_variables := {env.name: data |
		env := container.env[_]
		data := env
	}

	environment_variables[env_var]
	environment_variables[env_var].valueFrom.fieldRef.fieldPath == field_path
}

deny[msg] {
	kubernetes.is_workload
	tag := universal_tags[_]
	label := sprintf("tags.datadoghq.com/%s", [tag])
	not input.metadata.labels[label]
	msg = sprintf("[DOG-01] %s %s must set %s label", [input.kind, name, label])
}

deny[msg] {
	template := kubernetes.workload_template(input)
	tag := universal_tags[_]
	label := sprintf("tags.datadoghq.com/%s", [tag])
	not template.metadata.labels[label]
	msg = sprintf("[DOG-01] %s %s must set %s template label", [input.kind, name, label])
}

deny[msg] {
	template := kubernetes.workload_template(input)
	tag := universal_tags[_]
	container := template.spec.containers[_]
	not container_env_var(container, tag)
	msg = sprintf("[DOG-01] %s %s container %s must have env var %s tag", [input.kind, name, container.name, tag])
}

deny[msg] {
	kubernetes.is_workload
	label := "tags.datadoghq.com/env"
	env := input.metadata.labels[label]
	not allowed_envs[env]
	msg = sprintf("[DOG-01] %s %s only allows env: %v", [input.kind, name, allowed_envs])
}

deny[msg] {
	template := kubernetes.workload_template(input)
	label := "tags.datadoghq.com/env"
	env := template.metadata.labels[label]
	not allowed_envs[env]
	msg = sprintf("[DOG-01] %s %s template only allows env: %v", [input.kind, name, allowed_envs])
}
