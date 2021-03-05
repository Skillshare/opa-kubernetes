# Rules

Refer to the acceptance test fixtures of passing examples of:

- [Common rules](test/fixtures/pass)
- [Datadog rules](test/fixtures/datadog)
- [User provided data](test/fixtures/data)

## MTA-01

Denies entities with an explicit `namespace`. Namespace should only be
sepcified by `kubectl apply --namespace`. Using an explicit
`namespace` creates confusion.

## MTA-02

Entity specifies labels defines [Kubernetes recommended
labels][labels].

## MTA-03

Entity template specifies labels defines [Kubernetes recommended
labels][labels].

## MTA-04

Entities does not include empty `labels` or `annotations`. If there
are none, then omit the key.

## MTA-05

Entities labels and annotations are strings.

## WRK-01

Resource `requests` and `limits` such that:

- `requests` <= `limits`
- CPU specified in floating point. Good: `1`. Bad: `1000m`
- Memory specified in `Mi` or `Gi`

## WRK-02

Container `volumeMount` names match a declared `volume`

## WRK-03

A declared `volumes` is mounted in at least one container.

## WRK-04

Container names do not contain invalid characters.

## WRK-05

Declared `env` name/value pairs specify string values.

Example:

```
env:
  - name: ENABLE_FEATURE
    value: true
```

Resolve by quoting all values.

```
env:
  - name: ENABLE_FEATURE
    value: 'true'
```

## DPL-01

Containers set `livenessProbe` and `readinessProbe` of any type.

## DPL-02

`spec.selector.matchLabels` is a subset of
`spec.template.metadata.labels`. Ensures that a `Deployment` will not
be rejected by the Kubernetes API for a mismatched selector.

## DPL-03

Container `livenessProbe` and `readinessProbe` that specifies a port
matches a declared `containerPort`.

## DPL-04

Container `livenessProbe` and `readinessProbe` are the same. This
**should not** be the case. Liveness and readiness are two different
conditions so the same probe (either an HTTP GET or exec command)
should not be used for both.

## JOB-01

Requires `Jobs` set an explicit `backoffLimit`. The default likely
does not work in all cases. This forces manifest authors to choose an
applicable `backoffLimit`.

## CFG-01

`ConfigMap` value keys are explicit strings.

Broken example:

```
data:
  ENABLE_FEATURE: true
```

Resolve by quoting all values.

```
data:
  ENABLE_FEATURE: 'true'
```

## SEC-01

`Secret` using `data` specify valid Base64 encoded keys.

## HPA-01

`spec.minReplicas <= spec.maxReplicas`

## CMB-01

Container `envFrom` references a `ConfigMap` or `Secret` declared in
the manifests.

## CMB-02

Volumes populated from `ConfigMap` or `Secret` match one declared in
the manifests.

## CMB-03

`Service` label selector matches a `Deployment` template labels.

## CMB-04

`HorizontalPodAutoscaler` scale target matches an entity declared in
the manifests.

## CMB-05

`Service` target port matches a `containerPort` in the matching
`Deployment`.

## CMB-06

`Deployment` managed by an HPA does not declare replicas. This
conflicts with the HPA's settings.

## DOG-01

Workloads specify the `ad.datadoghq.com/tags` annotation.

Validate workloads set specific tags by by providing a data file to
`conftest`.

```
# data/datadog_required_tags.yaml
datadog_required_tags:
  - environment
  - service
```

Next pass the `-d` or `--data` argument to conftest:

```
conftest test --data data
```

## DOG-02

Workloads containers specify the `ad.datadoghq.com/$container.logs` annotation.

Example valid annotation:

```
ad.datadoghq.com/dummy.logs: |
  [{ "source": "docker", "service": "dummy" }]
```

Where `dummy` is a declared container.

## SBX-01

Check the `apps` ingress whitelists our vpns. Exampl valid annotation:

```
annotations:
  kubernetes.io/ingress.class: apps
  nginx.ingress.kubernetes.io/whitelist-source-range: "34.196.181.12/32,35.175.17.80/32"
```

## SBX-02

`HorizontalPodAutoscaler` has two or less `maxReplicas`. This keeps
resource utilization low on the cluster.

## STG-01

Check the `apps` ingress whitelists our vpns. Exampl valid annotation:

```
annotations:
  kubernetes.io/ingress.class: apps
  nginx.ingress.kubernetes.io/whitelist-source-range: "34.196.181.12/32,35.175.17.80/32"
```

[labels]: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels
