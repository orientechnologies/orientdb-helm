{{- define "orientdb-helm.labels" -}}
{{ include "orientdb-helm.selectorLabels" . }}
{{- end }}

{{- define "orientdb-helm.selectorLabels" -}}
app: {{ .Values.labelValue }}
{{- if .Values.customLabels }}
{{- range $key, $val := .Values.customLabels }}
{{ $key }}: {{ $val }}
{{- end }}
{{- end }}
{{- end }}

{{- define "orientdb-helm.security-config" -}}
{{- if .Values.security.customSecurityConfigFile }}
{{- .Files.Get .Values.security.customSecurityConfigFile }}
{{- else }}
{{- tpl (.Files.Get "conf/security.json") . }}
{{- end }}
{{- end }}
