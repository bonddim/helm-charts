{{- define "base.daemonset" -}}
{{- include "base.utils.merge" (set . "base" "base.deployment.tpl") }}
{{- end -}}

{{- define "base.daemonset.tpl" -}}
apiVersion: {{ include "common.capabilities.daemonset.apiVersion" . }}
kind: DaemonSet
metadata: {{- include "base.metadata" . | nindent 2 }}
spec:
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
