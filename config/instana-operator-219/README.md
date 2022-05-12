## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for the operator pod. |
| clusterDomain | string | `""` | Specifies a custom cluster domain. |
| extraArgs | list | `[]` | Additional CLI arguments for the operator process. |
| extraEnv | list | `[]` | Additional environment variables for the operator process. |
| fullnameOverride | string | `""` | Overrides the chart's fullname (instana-operator). |
| hostNetwork | bool | `false` | Use the host's network namespace. Enabling this also sets 'dnsPolicy' to 'ClusterFirstWithHostNet'. |
| image.registry | string | `"containers.instana.io"` | The image registry to use. |
| image.repository | string | `"instana/release/selfhosted/operator"` | The image repository to use. |
| image.tag | string | Automatically set by the kubectl plugin | The image tag to use. |
| imagePullPolicy | string | `"IfNotPresent"` | The image pull policy. |
| imagePullSecrets | list | `[]` | A list of image pull secrets. |
| installCRDs | bool | `true` | Specifies whether CRDs should be installed. |
| nameOverride | string | `""` | Overrides the chart's name (instana-operator). |
| nodeSelector | object | `{}` | Node selector for the operator pod. |
| podSecurityContext | object | `{"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532}` | Security context for the operator pod. |
| replicas | int | `1` | The number of replicas to create. |
| resources | object | `{}` | Resource requests and limits for the operator pod. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Security context for the operator container. |
| tolerations | list | `[]` | Tolerations for the operator pod. |
| webhook.caBundleBase64 | string | `""` | Base64-encoded CA bundle for the webhook. |
