{{/*
Create secret to access docker registry
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .Values.images.registry.server (printf "%s:%s" .Values.images.registry.ImagePullSecret.username .Values.images.registry.ImagePullSecret.agent_key | b64enc) | b64enc }}
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
# SAML/OIDC configuration
serviceProviderConfig:
  # Password for the key/cert file
  keyPassword: instana
  # The combined key/cert file
  pem: |
      -----BEGIN RSA PRIVATE KEY-----
      Proc-Type: 4,ENCRYPTED
      DEK-Info: AES-128-CBC,454EDB8E011CC2539802B758DFEEC60C

      3/5qV/8jaLTr2GY50ZM5KlNGx2mqoR8eI76nE50WNZxn3UgSQLObrGOzYPLeKNex
      YWfoJ1K1mRB5vnmrRksUaLAA3g8Q630iLmrcmdGpWTtdihJ6898iuwcXtM0cVbqT
      W2DpiLuuMYoKDHwA6c4JpCynKMxb1lAdfZBlFJK5w/lvQSOgmdMtwSQPCFG/MWTM
      EHNkDdfdaZVBye4WhMLetOzXJ7npdNgN3Own0zq3Jq/SWFhtKODk8w/3aaxMCjVS
      e3TfMJvAeAWjQO2oj4zQstgTEkhypu3mhugY6rZJKqS5OQFOqFcmAo1m4dQlPGbr
      VZ1WkJAsDkpYMzmCvq5ka6NjA0OxGWNEVculL06dfL7+pGJzBpc4hZDMMD6QOsP+
      cYjZKgsiv8OQHM4qOrpZzSTaSyu+lRXhV9P+drSFHEU1KaYKVVoIFd13vLVLDKfY
      sAEDrDDthNIvvWcemj5L+3UwwcamMK6ZUSdgp+VKpw8phwVg9zZLuPT3e3qjBT3f
      19atPnux7WGghmfj5zJiOGFcItGW2EI69/tnGVarBGZTe567mtYrNtmRSFdZ/V5t
      pFaRxPROf8OoyZ6NadZ8oEGLZRlJB/BBhHxiCcip1rMN99oVEXqdHNjnBomGU1gG
      0O9wTmP98NIFNHSJDTx3je+fR7X3B1IMJBJs8Yrj/EZUd+RNYfQaOh9jk9qmEx+p
      dT3BsW8QVn6J6PSEcVW9z/7+78c4rimijXgXMsVWqti8m4E8d1ZzkWUNkKVG9SDR
      WjDmpBhIUH859lbMKA2dJVnHl4s/GPo9h/v1dLEzR/udbskV8cAJ+7rqF6fIdxfd
      c553MV9TQJDMKzSybNrQquxI2huGl3UGMZxO0sv8zY8I6cksorDmnWincq8QFzI/
      t2hQzEVnjtFT1W1cQdOSLUFkXtuqaTK4ZchnqWYJRiRSXYILK0QT+e6a7H3/tBjQ
      ScTjWrbaECO1iaHtjt/bOjKiG9cxcq+CwOTUyXMznNF2Pm9EKKnAc6elF5Y/fu4Z
      37nP+xScvq3meM2CbrWHgGGxJKafWhqLJC9+EF52faTICrNHmKP+lfkVdU/C7m4H
      zRbeC+2ARn0xaNxuf/xqVvNBFCKSUaJkkeH0dr5nKrhd53/Pp/Bw2ohnSJTcm0Yj
      nEznYYslAzzc+AeH+/KIjiw+8GJCFsxhrejg9IAb5x8v8sblu/IlOG1uR885ZvFH
      BbxLUdNzCr0AOujatedpLl8Z1npYpk2mpWpxbkEbUstC+pCZkfpQHD9o4qASh5qs
      xKDPai1NOJspnrsj+F4boMAZM2wcyuyVz5vU5cBkyiZ3v4UrZSdN0EAcB3azOnC2
      tolvyrTkrMTA2FFMvQUlTKBpB20uTaJdc0PoU29Ie0lnN53u2UUDGaOWeEJSpQVM
      QOncFNXh2PXL06mMDNInVIsDNC1wrwkQW3zNOCciH+SMzYPutP6ljO3Q13oSYTF2
      TR26BvFm4RilQIL3Vl2Ps1d43SWj0Ao4vxwmpj95yi0ir9G+VruYNcyOM5pnwqPk
      0PcRWJGyRJpPaNj5q5lygqwR50lB341diYx72K3zuPHvy7NPSBiflNzmDNOyBMEl
      -----END RSA PRIVATE KEY-----
      -----BEGIN CERTIFICATE-----
      MIID+TCCAuGgAwIBAgIUDdCYnFFALJK7JitBJ6jSzR/Dvd0wDQYJKoZIhvcNAQEL
      BQAwgYsxCzAJBgNVBAYTAlhYMRUwEwYDVQQHDAxEZWZhdWx0IENpdHkxHDAaBgNV
      BAoME0RlZmF1bHQgQ29tcGFueSBMdGQxJTAjBgNVBAMMHGNhdGFseXN0LmFpb3Bz
      LWluc3RhbmEubG9jYWwxIDAeBgkqhkiG9w0BCQEWEW1pbi5qaS5nekBpYm0uY29t
      MB4XDTIyMTEzMDEwMTUzMloXDTMyMTEyNzEwMTUzMlowgYsxCzAJBgNVBAYTAlhY
      MRUwEwYDVQQHDAxEZWZhdWx0IENpdHkxHDAaBgNVBAoME0RlZmF1bHQgQ29tcGFu
      eSBMdGQxJTAjBgNVBAMMHGNhdGFseXN0LmFpb3BzLWluc3RhbmEubG9jYWwxIDAe
      BgkqhkiG9w0BCQEWEW1pbi5qaS5nekBpYm0uY29tMIIBIjANBgkqhkiG9w0BAQEF
      AAOCAQ8AMIIBCgKCAQEAynL2uWiIDeVRlmUc7Pv/1Z9BJPPz3l+RbPbm5iwBrlTV
      5UdrgmCEw5+3XZ4B9l2nfr04We8g4lsV6C07+W1TmpewMU8RYNoJFWMu1gBnTPl/
      azVh6Q376PShRAJv0k/mNtl0aiUxeoeeyzoSoaVYmkfr0CBmQyaqGXHY0Ss+G8dJ
      iWsA2jH52IVGFlj/tgVTAOcQOBNOmUwLadZ/KCiZF98NGDR2+aeYv2OVPEp1IBsb
      RKHLVNi9Wv5GCgm0VWSnY3LKL6nq44+L6dmKmqfooZ+ESialWhulcpSK96cbb6Mg
      6wKC7DXUTPw5LDS295ZJ2oLnU+9oxMTANfOC8N+KuwIDAQABo1MwUTAdBgNVHQ4E
      FgQUE1+sO745oXgTA9+1g9ZOZsM6IDIwHwYDVR0jBBgwFoAUE1+sO745oXgTA9+1
      g9ZOZsM6IDIwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAWVPT
      xJl6A+kO4UDzDTqYUxnRn8Ws3E5YBtJ6gecZcOHMk96+T82JVl9aBjTGSDlvKORe
      IU/OT1iPhZ9Qbg91a6m9t8/UO8v9/cJ3yMC5UO0MqrGdD9nIARXmdve6uXqmqEAT
      2wTY1hxVxD3JKMYnKPfuzLQzYaQt/Nuie/GyuU80tCwH+6ptOWPAxtpph15MniIP
      /6nF4+8uZR7xFtg1CABOkjwxGS9Xaj7xEzyNULUC+FGsEtaKWYQlA9pIL9TWqLiA
      60l4cHIcJFnhAs3s0nYFgvCC7Z5CETvVQisw7DHroam/R74x1UEy5PhLl5Ny2iOR
      iudx+lMxJN5/MnC8Xw==
      -----END CERTIFICATE-----#
{{- end }}

{{/*
set datastore images tag
*/}}
{{- define "ds-tag" }}
:latest
{{- end }}