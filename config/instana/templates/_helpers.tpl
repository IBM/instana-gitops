{{/*
Create secret to access docker registry
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.images.registry.server (printf "%s:%s" .Values.images.registry.ImagePullSecret.username .Values.images.registry.ImagePullSecret.agent_key | b64enc) | b64enc }}
{{- end }}
{{/*
Add '/' to registry if needed.
*/}}
{{- define "registry" -}}
{{ if .Values.images.registry.server }}{{- printf "%s/" .Values.images.registry.server -}}{{end}}
{{- end -}}