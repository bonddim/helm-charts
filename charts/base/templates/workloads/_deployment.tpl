{{- define "base.deployment" -}}
{{- include "base.utils.merge" (set . "base" "base.deployment.tpl") }}
{{- end -}}

{{- define "base.deployment.tpl" -}}
apiVersion: {{ include "common.capabilities.deployment.apiVersion" . }}
kind: Deployment
metadata: {{- include "base.metadata" . | nindent 2 }}
spec:
  {{- with .Values.replicaCount }}
  replicas: {{ . }}
  {{- end }}
  {{ with .Values.revisionHistoryLimit }}
  revisionHistoryLimit: {{ . }}
  {{ end }}
  selector:
    matchLabels: {{- include "base.labels.matchLabels" (dict "context" . "customLabels" .Values.podLabels) | nindent 6 }}
  {{- with .Values.updateStrategy }}
  strategy: {{- toYaml . | nindent 4 }}
  {{- end }}
  template: {{- include "base.pod.tpl" . | nindent 4 }}
{{- end -}}
