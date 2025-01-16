{{/*
Create a default fully qualified resource name.
Appends the component name if it is set in values or in template args.
{{ include "base.names.fullname" . -}}
{{ include "base.names.fullname" (dict "context" $ "component" "string") -}}
*/}}
{{- define "base.names.fullname" -}}
{{- $ctx := default . .context -}}
{{- if or $ctx.Values.component .component -}}
  {{- printf "%s-%s" (include "common.names.fullname" $ctx) (default $ctx.Values.component .component) | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- include "common.names.fullname" $ctx -}}
{{- end -}}
{{- end -}}
