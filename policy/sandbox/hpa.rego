package sandbox

import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_hpa
	input.spec.maxReplicas > 2
	msg = sprintf("[SBX-02] HorizontalPodAutoscaler %s must have <= 2 replicas", [name])
}
