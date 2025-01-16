{{- define "base.clusterRole" -}}
apiVersion: {{ include "common.capabilities.rbac.apiVersion" . }}
kind: ClusterRole
metadata: {{- include "base.metadata" . | nindent 2 }}
rules: {{- toYaml .Values.rbacRulesCluster | nindent 2 }}
{{- end -}}
