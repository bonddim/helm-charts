{{- define "base.job" -}}
{{ include "base.utils.merge" (set . "base" "base.job.tpl") }}
{{- end -}}

{{- define "base.job.tpl" -}}
apiVersion: {{ include "common.capabilities.cronjob.apiVersion" (default . .context) }}
kind: Job
metadata: {{- include "base.metadata" (dict "context" . "values" .Values.job) | nindent 2 }}
spec: {{- include "base.job.spec" (dict "context" . "jobValues" .Values.job) | nindent 2 }}
{{- end -}}

{{- define "base.job.spec" -}}
template: {{- include "base.pod.tpl" .context | nindent 4 }}
{{- with .jobValues }}
{{- with .activeDeadlineSeconds }}
activeDeadlineSeconds: {{ . | int }}
{{- end }}
{{- with .backoffLimit }}
backoffLimit: {{ . | int }}
{{- end }}
{{- with .completionMode }}
completionMode: {{ . }}
{{- end }}
{{- with .completions }}
completions: {{ . | int }}
{{- end }}
{{- with .parallelism }}
parallelism: {{ . | int }}
{{- end }}
{{- with .suspend }}
suspend: {{ . }}
{{- end }}
{{- with .ttlSecondsAfterFinished }}
ttlSecondsAfterFinished: {{ . | int }}
{{- end }}
{{- end }}
{{- end }}
