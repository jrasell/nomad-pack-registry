job "counter-ui" {

  region      = [[ .countdash.region | quote ]]
  datacenters = [[ .countdash.datacenters | toStringList ]]
  namespace   = [[ .countdash.namespace | quote ]]

  group "counter" {
    network {
      mode = [[ .countdash.network_mode | quote ]]
      port "ui" {
        to = "9002"
      }
    }

    service {
      name     = "counter-ui"
      port     = "ui"
      provider = [[ .countdash.service_provider | quote ]]
    }

    task "ui" {
      driver = "docker"

      config {
        image = "hashicorpnomad/counter-dashboard:v3"
        ports = ["ui"]
      }

      template {
        data = <<EOH
[[ if eq .countdash.service_provider "nomad" -]]{{- range nomadService "counter-api" -}}
[[ else if eq .countdash.service_provider "consul" -]]{{- range service "counter-api" -}}[[ end ]]
COUNTING_SERVICE_URL=http://{{ .Address }}:{{ .Port }}{{ end }}
EOH

        destination = "local/env.txt"
        env         = true
      }
    }
  }
}