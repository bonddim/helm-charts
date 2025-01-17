{{- define "base.cronjob" -}}
{{- include "base.utils.merge" (set . "base" "base.cronjob.tpl") }}
{{- end -}}

{{- define "base.cronjob.tpl" -}}
apiVersion: {{ include "common.capabilities.cronjob.apiVersion" . }}
kind: CronJob
metadata: {{- include "base.metadata" (dict "context" . "values" .Values.cronjob) | nindent 2 }}
spec:
  {{- with .Values.cronjob }}
  {{- with .concurrencyPolicy }}
  concurrencyPolicy: {{ . }}
  {{- end }}
  {{- with .failedJobsHistoryLimit }}
  failedJobsHistoryLimit: {{ . | int }}
  {{- end }}
  schedule: {{ .schedule | quote }}
  {{- with .startingDeadlineSeconds }}
  startingDeadlineSeconds: {{ . | int }}
  {{- end }}
  {{- with .successfulJobsHistoryLimit }}
  successfulJobsHistoryLimit: {{ . | int }}
  {{- end }}
  {{- with .suspend }}
  suspend: {{ . }}
  {{- end }}
  {{- with .timeZone }}
  timeZone: {{ . }}
  {{- end }}
  {{- end }}
  jobTemplate:
    spec: {{- include "base.job.spec" (dict "context" $ "jobValues" .Values.cronjob.job) | nindent 6 }}
{{- end -}}
