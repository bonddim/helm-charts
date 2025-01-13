{{/*
Render template from provided value and merge it with the base.metadata template.
{{ include "base.extra" (dict "context" $ "tpl" .Values.extraTemplate) -}}
*/}}
{{- define "base.extra" -}}
{{- include "common.tplvalues.merge-overwrite" (dict "context" .context "values" (list (include "base.metadata" .context) .tpl)) -}}
{{- end }}
