{{- define "otel.demo.deployment" }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "otel-demo.name" . }}-{{ .name }}
  labels:
    {{- include "otel-demo.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "otel-demo.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "otel-demo.selectorLabels" . | nindent 8 }}
    spec:
      {{- if .imageConfig.pullSecrets }}
      imagePullSecrets:
        {{- toYaml .imageConfig.pullSecrets | nindent 8}}
      {{- end }}
      {{- with .serviceAccountName }}
      serviceAccountName: {{ .serviceAccountName}} 
      {{- end }}
      containers:
        - name: {{ .name }}
          image: {{ .image | default (printf "%s:v%s-%s" .imageConfig.repository .Chart.AppVersion (.name | replace "-" "")) }}
          {{- if or .ports .servicePort}}
          ports:
            {{- include "otel-demo.pod.ports" . | nindent 10 }}
          {{- end }}
          env:
            {{- include "otel-demo.pod.env" . | nindent 10 }}
           
{{- end }}