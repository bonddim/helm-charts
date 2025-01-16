{{- define "base.clusterRoleBinding" -}}
apiVersion: {{ include "common.capabilities.rbac.apiVersion" . }}
kind: ClusterRoleBinding
metadata: {{- include "base.metadata" . | nindent 2 }}
subjects:
  - kind: ServiceAccount
    name: {{ include "base.serviceaccount.name" . }}
    namespace: {{ include "common.names.namespace" . }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ include "base.names.fullname" . }}
{{- end -}}
