{{- define "base.metadata" -}}
metadata:
  {{- with .Values.commonAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "common.names.fullname" . }}
{{- end -}}
