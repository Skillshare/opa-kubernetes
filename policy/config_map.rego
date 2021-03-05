package main

import data.kubernetes

name = input.metadata.name

deny[msg] {
	kubernetes.is_config_map
	some key
	value := input.data[key]
	not is_string(value)
	msg = sprintf("[CFG-01] ConfigMap %s data key %s must be a string", [name, key])
}
