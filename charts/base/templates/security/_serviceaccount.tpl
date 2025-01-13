{{- define "base.serviceaccount" -}}
{{- include "base.utils.merge" (set . "base" "base.serviceaccount.tpl") }}
{{- end -}}

{{- define "base.serviceaccount.tpl" -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  {{- with (merge .Values.serviceAccount.annotations .Values.commonAnnotations) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" . | nindent 4 }}
  name: {{ include "base.serviceaccount.name" . }}
  namespace: {{ include "common.names.namespace" . }}
{{- end -}}

{{- define "base.serviceaccount.name" -}}
{{- if .Values.serviceAccount.create -}}
  {{ default (include "base.names.fullname" .) .Values.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- else -}}
  {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
