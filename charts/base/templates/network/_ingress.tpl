{{- define "base.ingress" -}}
{{- include "base.utils.merge" (set . "base" "base.ingress.tpl") }}
{{- end -}}

{{- define "base.ingress.tpl" -}}

apiVersion: {{ include "common.capabilities.ingress.apiVersion" $ }}
{{- with .Values.ingress }}
kind: Ingress
metadata:
  {{- with (merge .annotations $.Values.commonAnnotations) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" $ | nindent 4 }}
  name: {{ default (include "base.names.fullname" $ ) .name }}
  namespace: {{ include "common.names.namespace" $ }}
spec:
  {{- if and .ingressClassName (eq "true" (include "common.ingress.supportsIngressClassname" $)) }}
  ingressClassName: {{ .ingressClassName | quote }}
  {{- end }}
  rules:
    - host: {{ .hostname | quote }}
      http:
        paths: {{- include "base.ingress.paths" (dict "context" $ "paths" .paths) | indent 10 }}
    {{- range .extraHosts }}
    - host: {{ .name | quote }}
      http:
        paths: {{ include "base.ingress.paths" (dict "context" $ "paths" .paths) | indent 10 }}
    {{- end }}
    {{- with .extraRules }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- if or .tls .extraTls (include "common.ingress.certManagerRequest" (dict "annotations" .annotations)) }}
  tls:
    {{- if or .tls (include "common.ingress.certManagerRequest" (dict "annotations" .annotations)) }}
    - hosts:
        - {{ .hostname | quote }}
      secretName: {{ printf "%s-tls" .hostname }}
    {{- end }}
    {{- with .extraTls }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end -}}
{{- end -}}
{{- end -}}


{{/*
Ingress path definition
{{- include "base.ingress.path" (dict "context" . "paths" .Values.ingress.paths) }}
*/}}
{{- define "base.ingress.paths" -}}
{{- $service := include "base.names.fullname" .context -}}
{{- range .paths }}
- path: {{ .path }}
  {{- if eq "true" (include "common.ingress.supportsPathType" $.context) }}
  pathType: {{ default "ImplementationSpecific" .pathType }}
  {{- end }}
  backend: {{- include "common.ingress.backend" (dict "serviceName" $service "servicePort" (default "http" .port) "context" $.context)  | nindent 4 }}
{{- end -}}
{{- end -}}
