{{- define "base.ingress" -}}
{{- include "base.utils.merge" (set . "base" "base.ingress.tpl") }}
{{- end -}}

{{- define "base.ingress.tpl" -}}

apiVersion: {{ include "common.capabilities.ingress.apiVersion" $ }}
kind: Ingress
metadata: {{- include "base.metadata" (dict "context" $ "values" .Values.ingress) | nindent 2 }}
spec:
{{- with .Values.ingress }}
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
Will generate default path "/" to "http" port if provided "paths" is empty
{{- include "base.ingress.path" (dict "context" . "paths" .Values.ingress.paths) }}
*/}}
{{- define "base.ingress.paths" -}}
{{- $service := include "base.names.fullname" .context -}}
{{- $firstPort := $.context.Values.ports | first }}
{{- $defaultPort := default $firstPort.containerPort $firstPort.port -}}
{{- range (ternary (list (dict "path" "/" "port" $defaultPort)) .paths (empty .paths)) }}
- path: {{ .path }}
  {{- if eq "true" (include "common.ingress.supportsPathType" $.context) }}
  pathType: {{ default "ImplementationSpecific" .pathType }}
  {{- end }}
  backend: {{- include "common.ingress.backend" (dict "serviceName" $service "servicePort" (default $defaultPort .port) "context" $.context)  | nindent 4 }}
{{- end -}}
{{- end -}}
