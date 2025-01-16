{{/*
Basic metadata for the resource.
{{- include "base.metadata" . -}}
{{- include "base.metadata" (dict "context" . "values" .Values.ingress -}}
*/}}
{{- define "base.metadata" -}}
{{- $ctx := default . .context -}}
{{- $values := default dict .values -}}
{{- with (merge (default dict $values.annotations) $ctx.Values.commonAnnotations) }}
annotations: {{- toYaml . | nindent 2 }}
{{- end }}
labels: {{- include "base.labels.standard" $ctx | nindent 2 }}
name: {{ default (include "base.names.fullname" $ctx ) $values.name }}
namespace: {{ include "common.names.namespace" $ctx }}
{{- end -}}

{{- define "base.metadata.tpl" -}}
metadata: {{- include "base.metadata" . | nindent 2 }}
{{- end -}}
