{{- define "base.role" -}}
apiVersion: {{ include "common.capabilities.rbac.apiVersion" . }}
kind: Role
metadata: {{- include "base.metadata" . | nindent 2 }}
rules: {{- toYaml .Values.rbacRules | nindent 2 }}
{{- end -}}
