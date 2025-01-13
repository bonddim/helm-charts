{{- define "base.secret" -}}
{{ include "base.utils.merge" (set . "base" "base.secret.tpl") }}
{{- end -}}

{{- define "base.secret.tpl" -}}
apiVersion: v1
kind: Secret
metadata:
  {{- with .Values.commonAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "common.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . }}
{{- end -}}
