{{- define "base.service" -}}
{{- include "base.utils.merge" (set . "base" "base.service.tpl") }}
{{- end -}}

{{- define "base.service.tpl" -}}
apiVersion: v1
kind: Service
metadata: {{- include "base.metadata" (dict "context" $ "values" .Values.service) | nindent 2 }}
spec:
  {{- with .Values.service.clusterIP }}
  clusterIP: {{ . }}
  {{- end }}
  {{- with .Values.service.externalIPs }}
  externalIPs: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.service.externalName }}
  externalName: {{ . }}
  {{- end }}
  {{- with .Values.service.externalTrafficPolicy }}
  externalTrafficPolicy: {{ . }}
  {{- end }}
  {{- with .Values.service.healthCheckNodePort }}
  healthCheckNodePort: {{ . }}
  {{- end }}
  {{- with .Values.service.loadBalancerIP }}
  loadBalancerIP: {{ . }}
  {{- end }}
  {{- with .Values.service.loadBalancerSourceRanges }}
  loadBalancerSourceRanges: {{- toYaml . | nindent 4 }}
  {{- end }}
  ports:
    {{- /* Use service.ports only if defined */ -}}
    {{- if .Values.service.ports }}
    {{- range .Values.service.ports }}
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
  {{- with .Values.service.publishNotReadyAddresses }}
  publishNotReadyAddresses: {{ . }}
  {{- end }}
  selector: {{- include "base.labels.matchLabels" (dict "context" $ "customLabels" $.Values.podLabels) | nindent 4 }}
  {{- with .Values.service.sessionAffinity }}
  sessionAffinity: {{ . }}
  {{- end }}
  {{- with .Values.service.sessionAffinityConfig }}
  sessionAffinityConfig: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.service.topologyKeys }}
  topologyKeys: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.service.type }}
  type: {{ . }}
  {{- end }}
{{- end -}}
