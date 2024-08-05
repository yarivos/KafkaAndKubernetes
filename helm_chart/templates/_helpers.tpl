{{/*
Expand the name of the chart.
*/}}
{{- define "helm_chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm_chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm_chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm_chart.labels" -}}
helm.sh/chart: {{ include "helm_chart.chart" . }}
{{ include "helm_chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm_chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm_chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "helm_chart.producer.selectorLabels" -}}
{{- include "helm_chart.selectorLabels" . }}
app: producer
{{- end }}

{{- define "helm_chart.consumer.selectorLabels" -}}
{{- include "helm_chart.selectorLabels" . }}
app: consumer
{{- end }}

{{- define "helm_chart.consumer.fullname" }}
{{- printf "%s-%s" (include "helm_chart.fullname" .) "consumer" }}
{{- end }}

{{- define "helm_chart.producer.fullname" }}
{{- printf "%s-%s" (include "helm_chart.fullname" .) "producer" }}
{{- end }}

{{- define "helm_chart.serviceAccountName" -}}
{{- printf "%s-%s" .Release.Name "sa" }}
{{- end }}

{{- define "helm_chart.kafkaService" -}}
{{- printf "%s-%s" .Release.Name "kafka" }}
{{- end }}

{{- define "helm_chart.kafkaBrokers" -}}
{{- printf "%s-%s:9092" .Release.Name "kafka" }}
{{- end }}
