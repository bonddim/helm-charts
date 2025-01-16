{{/*
Kubernetes standard labels
Wrapper around Bitnami's "common.labels.standard" to add component label and .Values.commonLabels
{{ include "base.labels.standard" . -}}
{{ include "base.labels.standard" (dict "context" $ "customLabels" .Values.podLabels) -}}
*/}}
{{- define "base.labels.standard" -}}
{{- $ctx := default . .context -}}
{{- $labels := include "common.labels.standard" (dict
      "context" $ctx
      "customLabels" (merge (default dict .customLabels) (default dict $ctx.Values.commonLabels))
    ) | fromYaml
-}}
{{- if $ctx.Values.component -}}
  {{- merge $labels (dict "app.kubernetes.io/component" $ctx.Values.component) | toYaml -}}
{{- else -}}
  {{- $labels | toYaml -}}
{{- end -}}
{{- end -}}

{{/*
Labels used on immutable fields such as deploy.spec.selector.matchLabels or svc.spec.selector
Wrapper around Bitnami's "common.labels.matchLabels" to add component label and .Values.commonLabels
{{- include "base.labels.matchLabels" (dict "context" $ "customLabels" .Values.podLabels) }}
*/}}
{{- define "base.labels.matchLabels" -}}
{{- $ctx := default . .context -}}
{{- $labels := include "common.labels.matchLabels" (dict
      "context" $ctx
      "customLabels" (merge (default dict .customLabels) (default dict $ctx.Values.commonLabels))
    ) | fromYaml
-}}
{{- if $ctx.Values.component -}}
  {{- merge $labels (dict "app.kubernetes.io/component" $ctx.Values.component) | toYaml -}}
{{- else -}}
  {{- $labels | toYaml -}}
{{- end -}}
{{- end -}}
