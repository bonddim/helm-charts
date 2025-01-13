{{- define "base.job" -}}
{{ include "base.utils.merge" (set . "base" "base.job.tpl") }}
{{- end -}}

{{- define "base.job.tpl" -}}
apiVersion: {{ include "common.capabilities.cronjob.apiVersion" (default . .context) }}
kind: Job
metadata:
  {{- with .Values.commonAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "base.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . }}
spec:
  template: {{- include "base.pod.tpl" . | nindent 4 }}
{{- end -}}
