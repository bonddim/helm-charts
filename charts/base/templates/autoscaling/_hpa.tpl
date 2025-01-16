{{- define "base.hpa" -}}
{{- include "base.utils.merge" (set . "base" "base.hpa.tpl") }}
{{- end -}}

{{- define "base.hpa.tpl" -}}
apiVersion: {{ include "common.capabilities.hpa.apiVersion" (dict "context" .) }}
kind: HorizontalPodAutoscaler
metadata: {{- include "base.metadata" (dict "context" . "values" .Values.autoscale) | nindent 2 }}
spec:
{{- with .Values.autoscale }}
  {{- with .behavior }}
  behavior: {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .maxReplicas }}
  maxReplicas: {{ .maxReplicas }}
  {{- end }}
  {{- with .minReplicas }}
  minReplicas: {{ . }}
  {{- end }}
  metrics:
    {{- if .targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        {{- if semverCompare "<1.23-0" (include "common.capabilities.kubeVersion" $) }}
        targetAverageUtilization: {{ .targetCPUUtilizationPercentage }}
        {{- else }}
        target:
          type: Utilization
          averageUtilization: {{ .targetCPUUtilizationPercentage }}
        {{- end }}
    {{- end }}
    {{- if .targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        {{- if semverCompare "<1.23-0" (include "common.capabilities.kubeVersion" $) }}
        targetAverageUtilization: {{ .targetMemoryUtilizationPercentage }}
        {{- else }}
        target:
          type: Utilization
          averageUtilization: {{ .targetMemoryUtilizationPercentage }}
        {{- end }}
    {{- end }}
    {{- toYaml .metrics |  nindent 4 }}
  scaleTargetRef:
    {{- if eq .scaleTargetRef.kind "Deployment" }}
    apiVersion: {{ include "common.capabilities.deployment.apiVersion" $ }}
    {{- else if eq .scaleTargetRef.kind "StatefulSet" }}
    apiVersion: {{ include "common.capabilities.statefulset.apiVersion" $ }}
    {{- else }}
    apiVersion: {{ .scaleTargetRef.apiVersion }}
    {{- end }}
    kind: {{ .scaleTargetRef.kind }}
    name: {{ default (include "base.names.fullname" $) .scaleTargetRef.name }}
{{- end -}}
{{- end -}}
