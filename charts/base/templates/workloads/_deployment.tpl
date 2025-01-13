{{- define "base.deployment" -}}
{{- include "base.utils.merge" (set . "base" "base.deployment.tpl") }}
{{- end -}}

{{- define "base.deployment.tpl" -}}
apiVersion: {{ include "common.capabilities.deployment.apiVersion" . }}
kind: Deployment
metadata:
  {{- with .Values.commonAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "base.names.fullname" . }}
  namespace: {{ include "common.names.namespace" . }}
spec:
  {{- if and .Values.replicaCount (not (.Values.autoscaling).enabled) }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  {{ with .Values.revisionHistoryLimit }}
  revisionHistoryLimit: {{ . }}
  {{ end }}
  selector:
    matchLabels: {{- include "base.labels.matchLabels" (dict "context" . "customLabels" .Values.podLabels) | nindent 6 }}
  template: {{- include "base.pod.tpl" . | nindent 4 }}
  {{- with .Values.updateStrategy }}
  strategy: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
