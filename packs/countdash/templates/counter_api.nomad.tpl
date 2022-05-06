job "counter-api" {

  region      = [[ .countdash.region | quote ]]
  datacenters = [[ .countdash.datacenters | toStringList ]]
  namespace   = [[ .countdash.namespace | quote ]]

  group "counter" {
    network {
      mode = [[ .countdash.network_mode | quote ]]
      port "api" {
        to = "9001"
      }
    }

    service {
      name     = "counter-api"
      port     = "api"
      provider = [[ .countdash.service_provider | quote ]]
    }

    task "api" {
      driver = "docker"

      config {
        image = "hashicorpnomad/counter-api:v3"
        ports = ["api"]
      }
    }
  }
}
