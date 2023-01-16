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
set the ca cert to operators
*/}}
{{- define "opeartor-ca-crt" }}
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURKakNDQWc2Z0F3SUJBZ0lSQU9rZ0NpUzFJVCswVnlCVk1tQnRFVTh3RFFZSktvWklodmNOQVFFTEJRQXcKSFRFYk1Ca0dBMVVFQXhNU2FXNXpkR0Z1WVMxM1pXSm9iMjlyTFdOaE1CNFhEVEl6TURFeE5qRTBNall6T0ZvWApEVE16TURFeE16RTBNall6T0Zvd0hURWJNQmtHQTFVRUF4TVNhVzV6ZEdGdVlTMTNaV0pvYjI5ckxXTmhNSUlCCklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFwLzZNSTlhbFNabG5ONTVmZmhxWVJVSGIKcmlBc2pTMlppL09TdW94RDdRVzhQVXg4ZUFmZGRrZW5Ibi8rcXY0dmVZVFlHUUIzQnZlZEhseEcrdVNvRDhsYwp1dTU2M21mUzNMT0s3bzF0UzB6SEVJcE5LNWNrdDlJcndKcDFXTkYrYkhaNDRHaGswTnhMNm4xTFdETjRYandVCjE2RUJzQjFnZWtobmhieldOOHdVNi9jbW5FTVBocXNSYnlyVnpsM2I4QS93cXExWWpUNGUxSzlsVzFLMjBvU3QKek5YRzZhS1VYYXFJb0JROGJ0M2Q1cUtCYTJXMGdEOXN6Yjl2QklJUmtQZ2hkdDZHK3hPSng2aEhGeFBTTDRQcgovRmFCdFZUN1JSZ1pEZjh3bjExS0dMZzZ0OXE0MWROMDlYcEJJVkVxci9XV3NCd3NKNndFOWl3U2owejFkUUlECkFRQUJvMkV3WHpBT0JnTlZIUThCQWY4RUJBTUNBcVF3SFFZRFZSMGxCQll3RkFZSUt3WUJCUVVIQXdFR0NDc0cKQVFVRkJ3TUNNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdIUVlEVlIwT0JCWUVGTE0vTk1ROWkvS1Y4M0hrOHRJQwpSN1l1clFZM01BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ1VkaU03a3U1THpvb09FYldkbkdreHlDWm1MMXpPCmprbkY4dWpQSGEyUjlidm5OeERDOExLUm5iNk5OcWVYUGNkQ0xtWTNiN0FqVDM4RFl6aTdkRFpSRFEzN283d00KTVhERnlRcjExYWNhS0FHS1IzN3NiUlJ4ZGVqWHoxU1llRC9CTkUrYWVEbjQ4dFNGb0hrY2ZIeUs3bGR4M1JEcwoyVGlyY1pjUlRXZFRSaHJrVWdoRkg3UmF2WW8veHUzamQyeVgydEkwWEoyaTVRbnFFZVVJZUFibXA1MDhvdE04CkI3Ti93VjVUMzZER3JvWS9ZRTZMenVSSUpFQVFkbjZ2WnBUTEhXK05iUHNFQnVTZXk2NXdTNjlDM1JHYkUxMXcKQTRqeHVvTWVFa0Q1N0RrZGhibnFNakRacTdjUHdDNkFPVWY2S1paZmRCcGlxS1dJYVZ3bSsyd0UKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
{{- end }}

{{/*
set the ca cert to operators
*/}}
{{- define "opeartor-ca-key" }}
LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBcC82TUk5YWxTWmxuTjU1ZmZocVlSVUhicmlBc2pTMlppL09TdW94RDdRVzhQVXg4CmVBZmRka2VuSG4vK3F2NHZlWVRZR1FCM0J2ZWRIbHhHK3VTb0Q4bGN1dTU2M21mUzNMT0s3bzF0UzB6SEVJcE4KSzVja3Q5SXJ3SnAxV05GK2JIWjQ0R2hrME54TDZuMUxXRE40WGp3VTE2RUJzQjFnZWtobmhieldOOHdVNi9jbQpuRU1QaHFzUmJ5clZ6bDNiOEEvd3FxMVlqVDRlMUs5bFcxSzIwb1N0ek5YRzZhS1VYYXFJb0JROGJ0M2Q1cUtCCmEyVzBnRDlzemI5dkJJSVJrUGdoZHQ2Ryt4T0p4NmhIRnhQU0w0UHIvRmFCdFZUN1JSZ1pEZjh3bjExS0dMZzYKdDlxNDFkTjA5WHBCSVZFcXIvV1dzQndzSjZ3RTlpd1NqMHoxZFFJREFRQUJBb0lCQUcxRjZOZ2k5WTZqSnYySgptYW5JR01YcjZiNGdsWG9iY0NZVmdKcXhSRG0zb2xMcEhvbGc3RS9VbWNNQUZLSWJCcnh2aWJUeGxYckZzOENjCjIxcTFReEJKdFhTdVRPTy8rdXV1S2ErejlLU25RMURoOVFKbXBPNmcyZTdGU1pGRmE0dVhvRmF2OE92ZWI4OE8KUXVVVFRiZFdNMlJ6Q1VzS1FNZ3BzcFRPV1RVZkQyUFpMWnp3aEd6WEFlMkpsNVMvdXpoTXovV1JNT3B4VWgvZwpJMUFRRk1iQ2RQT1VlTTlQRkRFOWszWGpFbFFHV252c05TMW0rY0JEcmk5NFZsZUtNT2V2WnEvN04xSXM5TnpCCjV3Y09wUzVXUlRvcTQxeXpyU0M0alV2dTV2Qy9RSU92RWxCNDZnMExiWVMwWFRyN0MxU1BWT3RQT2lEYlAvNzkKczk1UFVoMENnWUVBMlVwUEF4OUNSdlMzWUw5OWhtWkc1Rmh2bTFDUzlhRmhGY1Y3SlhiT3lwQXhRNUkyc1VNZAp2WHZydlFWcmR1eXBONUZoTUh4MTZCeWErMW4ybVdFRVZaOGN4eFVGRi80Q1hlb0NpcUt6eXVDbytaWm9LQVdZCkxuOVhmZ250dFFqTFZnaXNYTVc0M2lRL3g0S3V5eE1icFd2SEx0SURqNGhCZlVMSVd5YUxxcXNDZ1lFQXhld1AKSHVya3JyY1VnU203UzdxejZPN2pud3B1Q1pDTko4eWlQZFp1TnZYQndJbDJaWFRMc1dPSWcrUmRlY3NPMGJ6WgpNNTRva2xRYW93WnYxTUd3U0x2WmJkcnBLbVpPN2Ywb25Ha1pYKzh6T2pnTXc1WWY2WlBZSDBlZFh2c2p4MDQ0Cnd6c2huZTZvOEYxYzBGbGh2Rmx1R0ZkdEp0MUFIWkxYdENScDRGOENnWUI2MHZNb3E2RzJKQndIOXhZSVE0WHQKQzBSREFkK2dNdEdERWZiVExYNGtxQzhBcUFSOFhKalNBOXMwSkgwall4RWYxUENnREtwRlF1NGtDQzFKYzdxVQpmM1V2MzJUYXMvMDRnczllK0NzekVaelNRRCt0NThPbS9OcEM1Mi9UZGg0aUNwTUxlY1JPNVNTY0xQV0syc2swCnoyQnV5YzJ6YzJ5NVZtZVVob3hLTXdLQmdETjFOMDB6aHZkQjFFdnNuS3lJd3lQSmtGYVdNSnUrQUdVYm1BYjUKekRmdjEwc0dza2lZZ0NrRGxzZXJ4UDNZWkdiMWNZY3hGSjFPem9vYUwxTWlkSUhFalRnNWxTdVg0K2VPVFZPMQpJNHJFdHczbzZyQ2pSSExISklhbGFPMzczNForK05VUmQ2RUhIdGMzZnQwUWtBK1hOTCtSWTJpYVY0UVkzSW9TCmVaQ0RBb0dCQUlBM25PRUc2QXFXb0crTFBHclhRN1VIeUx6QkJvTlkzbkx3L2U4MEFFc2o2UGQ1REFMR2NjRksKZDExOXdPWm1QYlBZYzdZbjg2b0tUeDZJNElRdmxGOEJCamZuSTdNckMrTkU4cmFqWWV6b3dtTjZibzNtY2hZSAo3b0RWdXVHOWZ0bys5cDNTcWQ5TWNOSExqVlZEaVZTeXBHK2UvNEhZRXdMRisyVFdmZzhCCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
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

