{{- define "base.statefulset" -}}
{{- include "base.utils.merge" (set . "base" "base.statefulset.tpl") }}
{{- end -}}

{{- define "base.statefulset.tpl" -}}
apiVersion: {{ include "common.capabilities.statefulset.apiVersion" . }}
kind: StatefulSet
metadata: {{- include "base.metadata" . | nindent 2 }}
spec:
  {{- with .Values.podManagementPolicy }}
  podManagementPolicy: {{ . }}
  {{- end }}
  {{- if and .Values.replicaCount (not (.Values.autoscaling).enabled) }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  {{ with .Values.revisionHistoryLimit }}
  revisionHistoryLimit: {{ . }}
  {{ end }}
  selector:
    matchLabels: {{- include "base.labels.matchLabels" (dict "context" . "customLabels" .Values.podLabels) | nindent 6 }}
  serviceName: {{ default (include "base.names.fullname" .) (.Values.service).name }}
  template: {{- include "base.pod.tpl" . | nindent 4 }}
  {{- with .Values.updateStrategy }}
  updateStrategy: {{ toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.volumeClaimTemplates }}
  volumeClaimTemplates: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
