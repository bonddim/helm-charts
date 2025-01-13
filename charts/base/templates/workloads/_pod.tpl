{{- define "base.pod" -}}
apiVersion: v1
kind: Pod
{{ include "base.utils.merge" (set . "base" "base.pod.tpl") }}
{{- end -}}

{{- define "base.pod.tpl" -}}
{{- $podLabels := merge .Values.podLabels .Values.commonLabels -}}
metadata:
  {{- with .Values.podAnnotations }}
  annotations: {{- toYaml . | nindent 4 }}
  {{- end }}
  labels: {{- include "base.labels.standard" (dict "customLabels" $podLabels "context" $) | nindent 4 }}
spec:
  {{- if .Values.affinity }}
  affinity: {{- toYaml . | nindent 4 }}
  {{- else }}
  affinity:
    {{- with (include "common.affinities.pods" (dict "type" .Values.podAffinityPreset "customLabels" $podLabels "context" . "component" .Values.component)) }}
    podAffinity: {{- . | nindent 6 }}
    {{- end }}
    {{- with (include "common.affinities.pods" (dict "type" .Values.podAntiAffinityPreset "customLabels" $podLabels "context" . "component" .Values.component)) }}
    podAntiAffinity: {{- . | nindent 6 }}
    {{- end }}
    {{- with (include "common.affinities.nodes" (dict "type" .Values.nodeAffinityPreset.type "key" .Values.nodeAffinityPreset.key "values" .Values.nodeAffinityPreset.values)) }}
    nodeAffinity: {{- . | nindent 6 }}
    {{- end }}
  {{- end }}
  {{- with (toYaml .Values.automountServiceAccountToken) }}
  automountServiceAccountToken: {{ .  }}
  {{- end }}
  {{- with .Values.initContainers }}
  initContainers: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) | indent 2 }}
  containers:
    {{- with .Values.sidecarContainers }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
    - name: {{ default (include "common.names.name" $) .Values.component }}
      image: {{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global "chart" .Chart) }}
      {{- with .Values.image.pullPolicy }}
      imagePullPolicy: {{ . }}
      {{- end }}
      {{- with .Values.args }}
      args: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.command }}
      command: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.env }}
      env:
        {{- range $name, $value := . }}
        - name: {{ $name }}
          {{ toYaml $value | nindent 10 }}
      {{- end }}
      {{- end }}
      {{- with .Values.envFrom }}
      envFrom: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.lifecycle }}
      lifecycle: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.livenessProbe }}
      livenessProbe: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.readinessProbe }}
      readinessProbe: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.startupProbe }}
      startupProbe: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if or .Values.service.port .Values.service.ports }}
      ports:
        {{- range .Values.service.ports }}
        - containerPort: {{ default .port .targetPort | int }}
          name: {{ .name }}
          protocol: {{ default "TCP" .protocol }}
        {{- end }}
        {{- if .Values.service.port }}
        - containerPort: {{ default .Values.service.port .Values.service.targetPort | int }}
          name: {{ default "http" .Values.service.name }}
          protocol: {{ default "TCP" .Values.service.protocol }}
        {{- end }}
      {{- end }}
      {{- if .Values.resources }}
      resources: {{- toYaml .Values.resources | nindent 8 }}
      {{- else if ne .Values.resourcesPreset "none" }}
      resources: {{- include "common.resources.preset" (dict "type" .Values.resourcesPreset) | nindent 8 }}
      {{- end }}
      {{- with .Values.securityContext }}
      securityContext: {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.volumeMounts }}
      volumeMounts: {{- toYaml . | nindent 8 }}
      {{- end }}
  {{- with .Values.dnsPolicy }}
  dnsPolicy: {{ . }}
  {{- end }}
  {{- with (toYaml .Values.enableServiceLinks) }}
  enableServiceLinks: {{ . }}
  {{- end }}
  {{- with .Values.hostNetwork }}
  hostNetwork: {{ . }}
  {{- end }}
  {{- with .Values.nodeSelector }}
  nodeSelector: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.priorityClassName }}
  priorityClassName: {{ . }}
  {{- end }}
  {{- with .Values.restartPolicy }}
  restartPolicy: {{ . }}
  {{- end }}
  {{- with .Values.runtimeClassName }}
  runtimeClassName: {{ . }}
  {{- end }}
  {{- with .Values.schedulerName }}
  schedulerName: {{ . }}
  {{- end }}
  {{- with .Values.podSecurityContext }}
  securityContext: {{- toYaml . | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ include "base.serviceaccount.name" . }}
  {{- with .Values.shareProcessNamespace }}
  shareProcessNamespace: {{ . }}
  {{- end }}
  {{- with .Values.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ . }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.topologySpreadConstraints }}
  topologySpreadConstraints: {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.volumes }}
  volumes: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
