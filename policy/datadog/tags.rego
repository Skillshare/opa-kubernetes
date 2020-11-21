package datadog

import data.kubernetes

universal_tags := ["env", "service", "version"]

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
	msg = sprintf("[DOG-01] %s must set %s label", [name, label])
}

deny[msg] {
	template := kubernetes.workload_template(input)
	tag := universal_tags[_]
	label := sprintf("tags.datadoghq.com/%s", [tag])
	not template.metadata.labels[label]
	msg = sprintf("[DOG-01] %s must set %s template label", [name, label])
}

deny[msg] {
	template := kubernetes.workload_template(input)
	tag := universal_tags[_]
	container := template.spec.containers[_]
	not container_env_var(container, tag)
	msg = sprintf("[DOG-01] %s container %s must have env var %s tag", [name, container.name, tag])
}
