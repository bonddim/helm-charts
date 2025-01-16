{{- define "base.roleBinding" -}}
apiVersion: {{ include "common.capabilities.rbac.apiVersion" . }}
kind: RoleBinding
metadata: {{- include "base.metadata" . | nindent 2 }}
subjects:
  - kind: ServiceAccount
    name: {{ include "base.serviceAccountName" . }}
    namespace: {{ include "common.names.namespace" . }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "base.names.fullname" . }}
{{- end -}}
