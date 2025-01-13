{{/*
Provide default values for the Helm chart templates.
Uncommented are used in the templates as fallback values.
Using defaults in named template avoids need to guess path in context if this chart is imported with alias.
*/}}
{{- define "base.defaults" -}}
### Common ###
# global: {}
nameOverride: ""
fullnameOverride: ""
namespaceOverride: ""
commonAnnotations: {}
commonLabels: {}

### Workload ###
# replicaCount:  # int
image: {}
  # registry: ""
  # repository: ""
  # pullPolicy: ""
  # pullSecrets: []
  # tag: ""
# args: []
# command: ""
# dnsPolicy: ""
enableServiceLinks: false
# env: {}
# envFrom: []
hostNetwork: false
# initContainers: []
# lifecycle: []
# livenessProbe: {}
# nodeSelector: {}
# affinity: {}
# podAffinityPreset: ""
# podAntiAffinityPreset: ""
nodeAffinityPreset: {}
#   type: ""
#   key: ""
#   values: []
podAnnotations: {}
podLabels: {}
# podSecurityContext: {}
# priorityClassName: ""
# readinessProbe: {}
# resources: {}
resourcesPreset: none
# restartPolicy: ""
# securityContext: {}
# sidecarContainers: []
# startupProbe: {}
# tolerations: []
# volumeMounts: []
# volumes: []

### Network ###
service:
  # name: "" # Override the name of the service resource
  annotations: {}
  # port:
  # portName: ""
  # type: ""
  # targetPort:
  # nodePort: ""
  # externalIPs: []
  # loadBalancerIP: ""
  # loadBalancerSourceRanges: []
  # appProtocol: ""
  # ports: []
ingress:
  # name: "" # Override the name of the ingress resource
  annotations: {}
  # ingressClassName: ""
  # hostname: ""
  # paths: []
  #   # - path: /
  #   #   pathType: ImplementationSpecific
  # tls: false
  # extraHosts: []
  # extraTls: []

### Security ###
automountServiceAccountToken: false
serviceAccount: {}
  # create: false
  # annotations: {}
  # name: "" # Override the name of the service account
{{- end -}}
