{{/*
Expand the name of the chart.
*/}}
{{- define "yotpo-assignment.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "yotpo-assignment.fullname" -}}
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
{{- define "yotpo-assignment.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "yotpo-assignment.labels" -}}
helm.sh/chart: {{ include "yotpo-assignment.chart" . }}
{{ include "yotpo-assignment.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "yotpo-assignment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "yotpo-assignment.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "yotpo-assignment.producer.selectorLabels" -}}
{{- include "yotpo-assignment.selectorLabels" . }}
app: producer
{{- end }}

{{- define "yotpo-assignment.consumer.selectorLabels" -}}
{{- include "yotpo-assignment.selectorLabels" . }}
app: consumer
{{- end }}

{{- define "yotpo-assignment.consumer.fullname" }}
{{- printf "%s-%s" (include "yotpo-assignment.fullname" .) "consumer" }}
{{- end }}

{{- define "yotpo-assignment.producer.fullname" }}
{{- printf "%s-%s" (include "yotpo-assignment.fullname" .) "producer" }}
{{- end }}

{{- define "yotpo-assignment.serviceAccountName" -}}
{{- printf "%s-%s" .Release.Name "sa" }}
{{- end }}

{{- define "yotpo-assignment.kafkaService" -}}
{{- printf "%s-%s" .Release.Name "kafka" }}
{{- end }}

{{- define "yotpo-assignment.kafkaBrokers" -}}
{{- printf "%s-%s:9092" .Release.Name "kafka" }}
{{- end }}
