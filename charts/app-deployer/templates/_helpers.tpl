{{/*
Application name.
*/}}
{{- define "app-deployer.name" -}}
{{- .Values.name }}
{{- end }}

{{/*
Namespace name.
*/}}
{{- define "app-deployer.namespace" -}}
{{- .Values.namespace.name }}
{{- end }}

{{/*
Selector labels (immutable subset used in matchLabels and pod labels).
*/}}
{{- define "app-deployer.selectorLabels" -}}
app: {{ include "app-deployer.name" . }}
app.kubernetes.io/name: {{ include "app-deployer.name" . }}
{{- end }}

{{/*
Standard labels applied to all resources.
*/}}
{{- define "app-deployer.labels" -}}
{{ include "app-deployer.selectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.runtime }}
app.openshift.io/runtime: {{ .Values.runtime }}
{{- end }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Annotations for resources (vcs-uri when set, plus extraAnnotations).
*/}}
{{- define "app-deployer.annotations" -}}
{{- $annotations := dict }}
{{- if .Values.vcsUri }}
{{- $_ := set $annotations "app.openshift.io/vcs-uri" .Values.vcsUri }}
{{- end }}
{{- with .Values.extraAnnotations }}
{{- $annotations = merge $annotations . }}
{{- end }}
{{- if $annotations }}
{{- toYaml $annotations }}
{{- end }}
{{- end }}

{{/*
Namespace labels: standard labels + Istio labels (when enabled) + namespace.labels.
*/}}
{{- define "app-deployer.namespaceLabels" -}}
{{ include "app-deployer.labels" . }}
{{- if .Values.namespace.istio.enabled }}
istio.io/dataplane-mode: {{ .Values.namespace.istio.dataplaneMode }}
istio.io/use-waypoint: {{ .Values.namespace.istio.useWaypoint }}
{{- end }}
{{- with .Values.namespace.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Derive service ports from container ports when .Values.service.ports is empty.
*/}}
{{- define "app-deployer.servicePorts" -}}
{{- if .Values.service.ports }}
{{- toYaml .Values.service.ports }}
{{- else }}
{{- range .Values.ports }}
- port: {{ .containerPort }}
  targetPort: {{ .containerPort }}
  protocol: {{ .protocol | default "TCP" }}
  name: {{ .name }}
{{- end }}
{{- end }}
{{- end }}
