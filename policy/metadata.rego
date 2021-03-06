package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
	input.metadata.namespace
	msg = sprintf("[MTA-01] %s cannot set explicit namespace", [name])
}

required_labels {
	not is_null(input.metadata.labels)
	input.metadata.labels["app.kubernetes.io/name"]
	input.metadata.labels["app.kubernetes.io/instance"]
	input.metadata.labels["app.kubernetes.io/version"]
	input.metadata.labels["app.kubernetes.io/component"]
	input.metadata.labels["app.kubernetes.io/part-of"]
	input.metadata.labels["app.kubernetes.io/managed-by"]
}

deny[msg] {
	not required_labels
	msg = sprintf("[MTA-02] %s must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels", [name])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	not required_labels with input as template
	msg = sprintf("[MTA-02] %s template must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels", [name])
}

deny[msg] {
	count(name) > 63
	msg = sprintf("[MTA-03] %s name is more than 63 characters", [name])
}

deny[msg] {
	not regex.match("^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$", name)
	msg = sprintf("[MTA-03] %s name must only contain: A-Z, a-z, -, _, and . characters.", [name])
}

deny[msg] {
	some key
	value := input.metadata[key]
	key == "annotations"
	is_null(value)
	msg = sprintf("[MTA-04] %s must not contain empty annotations.", [name])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	some key
	value := template.metadata[key]
	key == "annotations"
	is_null(value)
	msg = sprintf("[MTA-04] %s must not contain empty annotations.", [name])
}

deny[msg] {
	some key
	value := input.metadata[key]
	key == "labels"
	is_null(value)
	msg = sprintf("[MTA-04] %s must not contain empty labels.", [name])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	some key
	value := template.metadata[key]
	key == "labels"
	is_null(value)
	msg = sprintf("[MTA-04] %s must not contain empty labels.", [name])
}

deny[msg] {
	some key
	value := input.metadata.labels[key]
	not is_string(value)
	msg = sprintf("[MTA-05] %s %s label %s must be a string", [name, input.kind, key])
}

deny[msg] {
	some key
	value := input.metadata.annotations[key]
	not is_string(value)
	msg = sprintf("[MTA-05] %s %s annotation %s must be a string", [name, input.kind, key])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	some key
	value := template.metadata.labels[key]
	not is_string(value)
	msg = sprintf("[MTA-05] %s %s template label %s must be a string", [name, input.kind, key])
}

deny[msg] {
	kubernetes.is_workload
	template := kubernetes.workload_template(input)
	some key
	value := template.metadata.annotations[key]
	not is_string(value)
	msg = sprintf("[MTA-05] %s %s template annotation %s must be a string", [name, input.kind, key])
}
