{{/*
Merge two YAML templates and output the result.
This takes a dict of values:
- base: the template name of the base - required
- context: the top context - (deaults to .) - optional
- scope: the scope of the values to be merged - optional
- tpl: the template name of the overrides - optional
{{ include "base.utils.merge" (set . "base" "base.configmap.tpl") }}
{{ include "base.utils.merge" (dict "base" "base.configmap.tpl" "context" .) }}
{{ include "base.utils.merge" (dict "base" "base.configmap.tpl" "context" . "scope" .Values.app) }}
{{ include "base.utils.merge" (dict "base" "base.configmap.tpl" "context" . "tpl" "example.configmap") }}
{{ include "base.utils.merge" (dict "base" "base.configmap.tpl" "context" ."scope" .Values.app  "tpl" "example.configmap") }}
*/}}
{{- define "base.utils.merge" -}}
{{- $context := default . .context -}}
{{- $ctx := omit $context "Values" -}}
{{- $valuesList := list (include "base.defaults" . | fromYaml) $context.Values.global -}}
{{- if .scope -}}
  {{- if hasKey .scope "component" -}}
    {{- /*
      Set required (non-overwritable) component values:
        Add "commonLabels" with "app.kubernetes.io/component" label
        Add "fullnameOverride" and "nameOverride" from top values
    */ -}}
    {{- $values := dict
      "commonLabels" (dict "app.kubernetes.io/component" .scope.component)
      "fullnameOverride" $context.Values.fullnameOverride
      "nameOverride" $context.Values.nameOverride
    -}}
    {{- /* Append component values. This will not fail if key with name == .component is not found in .Values */ -}}
    {{- $valuesList = append $valuesList (mustMerge $values .scope) -}}
  {{- else -}}
    {{- fail "component key with component's name is required in values" -}}
  {{- end -}}
{{- else -}}
  {{- $valuesList = append $valuesList $context.Values -}}
{{- end -}}

{{- /* Merge rendrered values */ -}}
{{- $_ := set $ctx "Values" (include "common.tplvalues.merge-overwrite" (dict "context" $context "values" (compact $valuesList)) | fromYaml) -}}

{{- /* Render and merge templates */ -}}
{{- /* If "tpl" is not set fallback merge with "base" */ -}}
{{- include "common.tplvalues.merge-overwrite" (dict "context" $ctx "values" (list (include .base $ctx) (include (default .base .tpl) $ctx))) -}}
{{- end -}}
