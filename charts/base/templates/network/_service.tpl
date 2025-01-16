{{- define "base.service" -}}
{{- include "base.utils.merge" (set . "base" "base.service.tpl") }}
{{- end -}}

{{- define "base.service.tpl" -}}
{{- with .Values.service }}
apiVersion: v1
kind: Service
metadata:
  {{- with (merge .annotations $.Values.commonAnnotations) }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" $ | nindent 4 }}
  name: {{ default (include "base.names.fullname" $) .name }}
  namespace: {{ include "common.names.namespace" $ }}
spec:
  {{- with .clusterIP }}
  clusterIP: {{ . }}
  {{- end }}
  {{- with .externalIPs }}
  externalIPs: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .externalName }}
  externalName: {{ . }}
  {{- end }}
  {{- with .externalTrafficPolicy }}
  externalTrafficPolicy: {{ . }}
  {{- end }}
  {{- with .healthCheckNodePort }}
  healthCheckNodePort: {{ . }}
  {{- end }}
  {{- with .loadBalancerIP }}
  loadBalancerIP: {{ . }}
  {{- end }}
  {{- with .loadBalancerSourceRanges }}
  loadBalancerSourceRanges: {{- toYaml . | nindent 4 }}
  {{- end }}
  ports:
    {{- range .ports }}
    - port: {{ .port | int }}
      protocol: {{ default "TCP" .protocol }}
      targetPort: {{ default .port .targetPort | int }}
      name: {{ .name }}
      {{- with .appProtocol }}
      appProtocol: {{ . }}
      {{- end }}
      {{- with .nodePort }}
      nodePort: {{ . | int}}
      {{- end }}
    {{- end }}
    {{- if .port }}
    - port: {{ .port | int }}
      protocol: {{ default "TCP" .protocol }}
      targetPort: {{ default .port .targetPort | int }}
      name: {{ default "http" .portName }}
      {{- with .appProtocol }}
      appProtocol: {{ . }}
      {{- end }}
      {{- with .nodePort }}
      nodePort: {{ . | int }}
      {{- end }}
    {{- end }}
  {{- with .publishNotReadyAddresses }}
  publishNotReadyAddresses: {{ . }}
  {{- end }}
  selector: {{- include "base.labels.matchLabels" (dict "customLabels" (merge $.Values.podLabels $.Values.commonLabels) "context" $) | nindent 4 }}
  {{- with .sessionAffinity }}
  sessionAffinity: {{ . }}
  {{- end }}
  {{- with .sessionAffinityConfig }}
  sessionAffinityConfig: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .topologyKeys }}
  topologyKeys: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .type }}
  type: {{ . }}
  {{- end }}
{{- end -}}
{{- end -}}
