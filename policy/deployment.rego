package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_deployment
	container := input.spec.template.spec.containers[_]
	not container.livenessProbe
	msg = sprintf("[DPL-01] Deployment %s container %s must specify livenessProbe", [name, container.name])
}

deny[msg] {
	kubernetes.is_deployment
	is_null(input.spec.selector.matchLabels)
	msg = sprintf("[DPL-02] Deployment %s must specify label selector", [name])
}

deny[msg] {
	kubernetes.is_deployment
	is_object(input.spec.selector.matchLabels)
	count(input.spec.selector.matchLabels) == 0
	msg = sprintf("[DPL-02] Deployment %s must specify label selector", [name])
}

deny[msg] {
	kubernetes.is_deployment
	is_null(input.spec.template.metadata.labels)
	msg = sprintf("[DPL-02] Deployment %s must specify metadata labels", [name])
}

deny[msg] {
	kubernetes.is_deployment
	is_object(input.spec.template.metadata.labels)
	count(input.spec.template.metadata.labels) == 0
	msg = sprintf("[DPL-02] Deployment %s must specify metadata labels", [name])
}

deny[msg] {
	kubernetes.is_deployment
	selectors := {[label, value] | some label; value := input.spec.selector.matchLabels[label]}
	labels := {[label, value] | some label; value := input.spec.template.metadata.labels[label]}
	count(selectors - labels) > 0
	msg = sprintf("[DPL-02] Deployment %s selector must match template labels", [name])
}

deny[msg] {
	kubernetes.is_deployment
	container := input.spec.template.spec.containers[_]
	probes := container_probes with input as container

	probe_ports := {port | port := probes[_].port}
	container_port_numbers := {port | port := container.ports[_].containerPort}
	container_port_names := {port | port := container.ports[_].name}

	container_ports := union({container_port_numbers, container_port_names})

	count(probe_ports - container_ports) != 0
	msg = sprintf("[DPL-03] Deployment %s container %s probes port must match container port", [name, container.name])
}

warn[msg] {
	kubernetes.is_deployment
	container := input.spec.template.spec.containers[_]
	container.livenessProbe.httpGet
	container.readinessProbe.httpGet
	container.livenessProbe.httpGet.path == container.readinessProbe.httpGet.path
	msg = sprintf("[DPL-04] Deployment %s container %s is reusing livenessProbe for readinessProbe", [name, container.name])
}

warn[msg] {
	kubernetes.is_deployment
	container := input.spec.template.spec.containers[_]
	container.livenessProbe.exec
	container.readinessProbe.exec
	container.livenessProbe.exec.command == container.readinessProbe.exec.command
	msg = sprintf("[DPL-04] Deployment %s container %s is reusing livenessProbe for readinessProbe", [name, container.name])
}
