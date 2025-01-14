{{- define "base.secret" -}}
{{ include "base.utils.merge" (set . "base" "base.secret.tpl") }}
{{- end -}}

{{- define "base.secret.tpl" -}}
apiVersion: v1
kind: Secret
metadata: {{- include "base.metadata" . | nindent 2 }}
{{- end -}}
