{{- define "base.service" -}}
{{- include "base.utils.merge" (set . "base" "base.service.tpl") }}
{{- end -}}

{{- define "base.service.tpl" -}}
{{- with .Values.service }}
apiVersion: v1
kind: Service
metadata: {{- include "base.metadata" (dict "context" $ "values" .) | nindent 2 }}
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
    {{- /* Use service.ports only if defined */ -}}
    {{- if .ports }}
    {{- range .ports }}
    - port: {{ .port | int }}
      targetPort: {{ default .port .targetPort | int }}
      {{- with .appProtocol }}
      appProtocol: {{ . }}
      {{- end }}
      {{- with .name}}
      name: {{ . }}
      {{- end }}
      {{- with .nodePort }}
      nodePort: {{ . | int}}
      {{- end }}
      {{- with .protocol }}
      protocol: {{ . }}
      {{- end }}
    {{- end }}
    {{- else }}
    {{- /* Use container's ports instead */ -}}
    {{- range $.Values.ports }}
    - port: {{ default .containerPort .port | int }}
      targetPort: {{ default .port .containerPort | int }}
      {{- with .appProtocol }}
      appProtocol: {{ . }}
      {{- end }}
      {{- with .name}}
      name: {{ . }}
      {{- end }}
      {{- with .nodePort }}
      nodePort: {{ . | int}}
      {{- end }}
      {{- with .protocol }}
      protocol: {{ . }}
      {{- end }}
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
