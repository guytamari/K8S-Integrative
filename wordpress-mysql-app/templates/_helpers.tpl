{{/*
Common labels
*/}}
{{- define "wordpress-mysql-app.labels" -}}
app.kubernetes.io/name: {{.Chart.Name}}
helm.sh/chart: {{.Chart.Name}}-{{.Chart.Version}}
app.kubernetes.io/instance: {{.Release.Name}}
app.kubernetes.io/managed-by: {{.Release.Service}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wordpress-mysql-app.selectorLabels" -}}
app.kubernetes.io/name: {{.Chart.Name}}
app.kubernetes.io/instance: {{.Release.Name}}
{{- end }}