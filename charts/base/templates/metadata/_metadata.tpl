{{/*
Basic metadata for the resource.
{{- include "base.metadata" . -}}
*/}}
{{- define "base.metadata" -}}
{{- with .Values.commonAnnotations }}
annotations: {{- toYaml . | nindent 2 }}
{{- end }}
labels: {{- include "base.labels.standard" . | nindent 2 }}
name: {{ include "base.names.fullname" . }}
namespace: {{ include "common.names.namespace" . }}
{{- end -}}

{{- define "base.metadata.tpl" -}}
metadata: {{- include "base.metadata" . | nindent 2 }}
{{- end -}}
