{{/*
Create a default fully qualified app name.
Appends the component name if it is set.
*/}}
{{- define "base.names.fullname" -}}
{{- if .Values.component -}}
  {{- printf "%s-%s" (include "common.names.fullname" .) .Values.component | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}
