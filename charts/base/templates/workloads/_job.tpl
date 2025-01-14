{{- define "base.job" -}}
{{ include "base.utils.merge" (set . "base" "base.job.tpl") }}
{{- end -}}

{{- define "base.job.tpl" -}}
apiVersion: {{ include "common.capabilities.cronjob.apiVersion" (default . .context) }}
kind: Job
metadata: {{- include "base.metadata" . | nindent 2 }}
spec:
  template: {{- include "base.pod.tpl" . | nindent 4 }}
{{- end -}}
