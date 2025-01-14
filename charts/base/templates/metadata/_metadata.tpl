{{/*
Basic metadata for the resource.
{{- include "base.metadata" . -}}
*/}}
{{- define "base.metadata" -}}
metadata:
  {{- with .Values.commonAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "base.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . }}
{{- end -}}
