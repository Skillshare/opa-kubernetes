package datadog

import data.kubernetes

name = input.metadata.name

datadog_agent_host {
	environment_variables := {env.name: data |
		env := input.env[_]
		data := env
	}

	env := environment_variables.DD_AGENT_HOST
	env.valueFrom.fieldRef.fieldPath == "status.hostIP"
}

deny[msg] {
	template := kubernetes.workload_template(input)
	container := template.spec.containers[_]
	not datadog_agent_host with input as container
	msg = sprintf("[DOG-02] %s container %s must set DD_AGENT_HOST from hostIP", [name, container.name])
}
