{{/*
Create secret to access docker registry
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.images.registry.server (printf "%s:%s" .Values.images.registry.username .Values.images.registry.agent_key | b64enc) | b64enc }}
{{- end }}

{{/*
Add '/' to registry if needed.
*/}}
{{- define "registry" }}
{{ if .Values.images.registry.server }}{{- printf "%s/" .Values.images.registry.server -}}{{end}}
{{- end }}

{{/*
Create secret to tenant0-unit0
*/}}
{{- define "tenant0-Secret" }}
{{- printf "initialAdminUser: %s
initialAdminPassword: %s
# The Instana license. Can be a plain text string or a JSON array encoded as string.
license: %s
# This would also work: '["mylicensestring"]'
# A list of agent keys. Specifying multiple agent keys enables gradually rotating agent keys.
agentKeys:
  - %s" .Values.initialAdminUser .Values.initialAdminPassword .Values.license .Values.agent_key| b64enc }}
{{- end }}

{{- define "core-Secret" }}
{{- printf "initialAdminUser: %s
initialAdminPassword: %s
# The Instana license. Can be a plain text string or a JSON array encoded as string.
license: %s
# This would also work: '["mylicensestring"]'
# A list of agent keys. Specifying multiple agent keys enables gradually rotating agent keys.
agentKeys:
  - %s" .Values.initialAdminUser .Values.initialAdminPassword .Values.license .Values.agent_key| b64enc }}
{{- end }}