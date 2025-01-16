{{/*
Provide default values for the Helm chart templates.
Uncommented are used in the templates as fallback values.
Using defaults in named template avoids need to guess path in context if this chart is imported with alias.
*/}}
{{- define "base.defaults" -}}
global: {}

### Common ###
fullnameOverride: ""
nameOverride: ""
namespaceOverride: ""
commonAnnotations: {}
commonLabels: {}

### Workloads ###
## Pod ##
podAnnotations: {}
podLabels: {}
nodeAffinityPreset: []
automountServiceAccountToken: false
enableServiceLinks: false
hostNetwork: false
## Container ##
image: {}
resourcesPreset: none
## CronJob ##
cronjob:
  schedule: ""
## Job ##
job:
  annotations: {}

### Network ###
service:
  annotations: {}
ingress:
  annotations: {}

### Security ###
serviceAccount:
  annotations: {}
{{- end -}}
