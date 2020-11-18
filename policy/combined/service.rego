package combined

matching_service_selector(service, deployments) {
	deployment_selectors := {[label, value] |
		some deployment, label
		value := deployments[deployment].spec.template.metadata.labels[label]
	}

	service_selector := {[label, value] |
		some label
		value := service.spec.selector[label]
	}

	count(service_selector - deployment_selectors) == 0
}

deny[msg] {
	deployments := {deployment | deployment := deployments_by_name[_]}

	service := services_by_name[_]
	not matching_service_selector(service, deployments)
	msg = sprintf("[CMB-03] Service %s selector must match a Deployment", [service.metadata.name])
}

matching_service_port(service, deployments) {
	target_ports := {port | port := service.spec.ports[_].targetPort}
	numbered_container_ports := {port | port := deployments[_].spec.template.spec.containers[_].ports[_].containerPort}
	named_container_ports := {port | port := deployments[_].spec.template.spec.containers[_].ports[_].name}
	container_ports := union({numbered_container_ports, named_container_ports})
	count(target_ports - container_ports) == 0
}

deny[msg] {
	deployments := {deployment | deployment := deployments_by_name[_]}

	service := services_by_name[_]
	not matching_service_port(service, deployments)
	msg = sprintf("[CMB-05] Service %s port must match container port", [service.metadata.name])
}
