package sandbox

import data.network

name = input.metadata.name

deny[msg] {
	input.kind == "Ingress"
	input.metadata.annotations["kubernetes.io/ingress.class"] == "apps"
	not input.metadata.annotations["nginx.ingress.kubernetes.io/whitelist-source-range"]
	msg = sprintf("[SBX-01] Ingress %s missing whitelist annotation", [name])
}

deny[msg] {
	input.kind == "Ingress"
	input.metadata.annotations["kubernetes.io/ingress.class"] == "apps"
	whitelist := input.metadata.annotations["nginx.ingress.kubernetes.io/whitelist-source-range"]
	ranges := {range | range := split(whitelist, ",")[_]}
	diff := data.network.vpn_cidr_blocks - ranges
	count(data.network.vpn_cidr_blocks - ranges) != 0
	msg = sprintf("[SBX-01] Ingress %s missing IP range whitelist", [name])
}
