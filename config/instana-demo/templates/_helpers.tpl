{{/*
Create secret to access docker registry
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.images.registry.server (printf "%s:%s" .Values.images.registry.ImagePullSecret.username .Values.images.registry.ImagePullSecret.password | b64enc) | b64enc }}
{{- end }}

{{/*
Add '/' to registry if needed.
*/}}
{{- define "registry" }}
{{ if .Values.images.registry.server }}
{{- printf "%s/" .Values.images.registry.server -}}
{{end}}
{{- end }}

{{/*
Define instana-datastore registry
*/}}
{{- define "ds-registry" }}
{{ if .Values.images.registry.server }}
{{ .Values.images.registry.server }}
{{end}}
{{- end }}

{{/*
set datastore images 
*/}}
{{- define "zk_image" }}
{{ .Values.images.registry.server }}/{{ .Values.images.registry.repo }}/zookeeper:{{ .Values.images.registry.datastore.zkTag }}
{{- end }}
{{- define "kafka_image" }}
{{ .Values.images.registry.server }}/{{ .Values.images.registry.repo }}/kafka:{{ .Values.images.registry.datastore.kafkaTag }}
{{- end }}
{{- define "es_image" }}
{{ .Values.images.registry.server }}/{{ .Values.images.registry.repo }}/elasticsearch:{{ .Values.images.registry.datastore.esTag }}
{{- end }}
{{- define "clickhouse_image" }}
{{ .Values.images.registry.server }}/{{ .Values.images.registry.repo }}/clickhouse:{{ .Values.images.registry.datastore.clickhouseTag }}
{{- end }}
{{- define "cockroachdb_image" }}
{{ .Values.images.registry.server }}/{{ .Values.images.registry.repo }}/cockroachdb:{{ .Values.images.registry.datastore.cockroachdbTag }}
{{- end }}
{{- define "cassandra_image" }}
{{ .Values.images.registry.server }}/{{ .Values.images.registry.repo }}/cassandra:{{ .Values.images.registry.datastore.cassandraTag }}
{{- end }}

{{/*
Create secret to tenant0-unit0
*/}}
{{- define "tenant0-Secret" }}
initialAdminUser: {{ .Values.initialAdminUser }}
initialAdminPassword: {{ .Values.initialAdminPassword }}
# The Instana license. Can be a plain text string or a JSON array encoded as string.
license: {{ .Values.license }}
# This would also work: '["mylicensestring"]'
# A list of agent keys. Specifying multiple agent keys enables gradually rotating agent keys.
agentKeys: 
  - {{ .Values.agent_key }}
{{- end }}

{{/*
Create secret to core
*/}}
{{- define "core-Secret" }}
adminPassword: {{ .Values.initialAdminUser }}
dhParams: |
  -----BEGIN DH PARAMETERS-----
  MIIBCAKCAQEA7Biw22eoDMN4JWIAE+meIyNGJSJam94xa95MeTGCS4oGpRY9S0yQ
  GiDODyu6EDjeTxNxsDu0bFQ3peGGAVw0TezZCVil+tM3XGLR8I9tErllaEFAwb1H
  Ur7wAG5HBwxtD72lJ8hTUWdS80NoK3JIleX4gE/JRi8enKLyTvW3EUCrHXSHI6Bx
  HbFZ9l1erjjhIsR4v4lEoy7UujoZlp2eVifi7u4yFuLhdvVSdN2kSXf4G31oK+jx
  Wm/Ia2H0VbJ7ox9K1tXPPMP/K7FIfAoxVlv+HF4heN2KFSDm2LaaOt4wRt5N1OFY
  t2OHU6Kz7ZnXXMjDMo+uaOTJ6FgCL4fX8wIBAg==
  -----END DH PARAMETERS-----
imagePullSecrets:
  - name: {{ .Values.images.registry.ImagePullSecret.name }}
downloadKey: {{ .Values.agent_key }}
salesKey: {{ .Values.sales_key }}
tokenSecret: uQOkH+Y4wU_0
emailConfig:
  # Required if SMTP is used for sending e-mails and authentication is required
  smtpConfig:
    user: mysmtpuser
    password: mysmtppassword
{{- end }}

