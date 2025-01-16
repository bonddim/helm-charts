{{- define "base.configmap" -}}
{{ include "base.utils.merge" (set . "base" "base.configmap.tpl") }}
{{- end -}}

{{- define "base.configmap.tpl" -}}
apiVersion: v1
kind: ConfigMap
metadata: {{- include "base.metadata" . | nindent 2 }}
{{- end -}}
