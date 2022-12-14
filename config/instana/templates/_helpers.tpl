{{/*
Create secret to access docker registry
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.images.registry.name (printf "%s:%s" .Values.images.registry.ImagePullSecret.username .Values.images.registry.ImagePullSecret.password | b64enc) | b64enc }}
{{- end }}
{{/*
Add '/' to registry if needed.
*/}}
{{- define "registry" -}}
{{ if .Values.images.registry.name }}{{- printf "%s/" .Values.images.registry.name -}}{{end}}
{{- end -}}