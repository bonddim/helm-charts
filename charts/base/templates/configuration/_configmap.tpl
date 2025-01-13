{{- define "base.configmap" -}}
{{ include "base.utils.merge" (set . "base" "base.configmap.tpl") }}
{{- end -}}

{{- define "base.configmap.tpl" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  {{- with .Values.commonAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "base.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . }}
{{- end -}}
