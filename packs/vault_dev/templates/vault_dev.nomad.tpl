job "[[ template "full_job_name" . ]]" {

  region      = [[ .vault_dev.region | quote ]]
  datacenters = [[ .vault_dev.datacenters | toStringList ]]
  namespace   = [[ .vault_dev.namespace | quote ]]

  group "vault" {

    network {
      port "http" {}
    }

    [[ if .vault_dev.nomad_service_provider -]]
    service {
      name     = "vault-server-http"
      provider = [[ .vault_dev.nomad_service_provider | quote ]]
      port     = "http"
    }
    [[- end ]]

    task "server" {
      driver = "docker"

      config {
        image   = "hashicorp/vault:[[ .vault_dev.vault_version ]]"
        ports   = [ "http" ]
        command = "vault"
        args    = [
          "server",
          "-dev",
          "-dev-root-token-id",
          "[[ .vault_dev.vault_dev_token_id ]]",
          "-dev-listen-address",
          "0.0.0.0:${NOMAD_PORT_http}",
        ]
      }
    }
  }
}
