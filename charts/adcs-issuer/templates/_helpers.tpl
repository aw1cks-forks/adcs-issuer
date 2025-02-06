{{/*
Expand the name of the chart, allowing for an override.
*/}}
{{- define "adcs-issuer.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully qualified app name. Truncate at 63 characters as required by the DNS naming spec.
*/}}
{{- define "adcs-issuer.fullname" -}}
{{- if .Values.fullnameOverride }}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
    {{- $name := include "adcs-issuer.name" . }}
    {{- if contains $name .Release.Name }}
        {{- .Release.Name | trunc 63 | trimSuffix "-" }}
    {{- else }}
        {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version for labeling purposes.
*/}}
{{- define "adcs-issuer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels used across Kubernetes objects.
*/}}
{{- define "adcs-issuer.labels" -}}
helm.sh/chart: {{ include "adcs-issuer.chart" . }}
{{ include "adcs-issuer.selectorLabels" . }}
{{- with .Chart.AppVersion }}
app.kubernetes.io/version: {{ quote . }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels to help identify related Kubernetes resources.
*/}}
{{- define "adcs-issuer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adcs-issuer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the service account name, with the option to override or use a default.
*/}}
{{- define "adcs-issuer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
    {{- .Values.serviceAccount.name | default (include "adcs-issuer.fullname" .) }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
