{{- define "base.networkpolicy" -}}
{{- include "base.utils.merge" (set . "base" "base.networkpolicy.tpl") }}
{{- end -}}

{{- define "base.networkpolicy.tpl" -}}
kind: NetworkPolicy
apiVersion: {{ include "common.capabilities.networkPolicy.apiVersion" . }}
metadata: {{- include "base.metadata" (dict "context" . "values" .Values.networkPolicy) | nindent 2 }}
spec:
  podSelector:
    matchLabels: {{- include "base.labels.matchLabels" (dict "context" $ "customLabels" .Values.podLabels) | nindent 6 }}
  policyTypes:
    - Ingress
    - Egress
  egress:
    {{- if .Values.networkPolicy.allowExternalEgress }}
    - {}
    {{- else }}
    - ports:
        {{- if .Values.networkPolicy.allowEgressDNS }}
        - port: 53
          protocol: UDP
        - port: 53
          protocol: TCP
        {{- end }}
    {{- with .Values.networkPolicy.extraEgress }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    {{- end }}
  ingress:
    - ports:
        {{- range .Values.ports }}
        - port: {{ default .port .containerPort | int }}
          {{- with .protocol }}
          protocol: {{ . }}
          {{- end }}
        {{- end }}
        {{- range .Values.networkPolicy.ingressExtraPorts }}
        - port: {{ .port }}
          {{- with .protocol }}
          protocol: {{ . }}
          {{- end }}
        {{- end }}
      {{- if not .Values.networkPolicy.allowExternal }}
      from:
        - podSelector:
            matchLabels: {{- include "base.labels.matchLabels" . | nindent 14 }}
        {{- with .Values.networkPolicy.ingressNSMatchLabels }}
        - namespaceSelector:
            matchLabels: {{- toYaml . | nindent 14 -}}
          {{- with .Values.networkPolicy.ingressNSPodMatchLabels }}
          podSelector:
            matchLabels: {{- toYaml . | nindent 14 -}}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- with .Values.networkPolicy.extraIngress }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
