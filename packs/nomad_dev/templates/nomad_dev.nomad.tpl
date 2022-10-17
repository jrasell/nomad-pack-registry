job [[ template "full_job_name" . ]] {

  region      = [[ .nomad_dev.region | quote ]]
  datacenters = [[ .nomad_dev.datacenters | toStringList ]]
  namespace   = [[ .nomad_dev.namespace | quote ]]

  [[ $packVars := .nomad_dev ]] [[ range $idx, $region := .nomad_dev.nomad_regions ]]

  group [[ $region.name | quote ]] {

    network {
      port "server_http" {
        static = [[ $region.initial_port | quote ]]
      }
      port "server_rpc" {
        static = [[ add 1 $region.initial_port | quote ]]
      }
      port "server_serf" {
        static = [[ add 2 $region.initial_port | quote ]]
      }
      port "client_http" {
        static = [[ add 3 $region.initial_port | quote ]]
      }
      port "client_rpc" {
        static = [[ add 4 $region.initial_port | quote ]]
      }
      port "client_serf" {
        static = [[ add 5 $region.initial_port | quote ]]
      }
    }

    [[ if $packVars.nomad_service_provider ]]
    service {
      name     = [[ printf "%s-server-1-http" $region.name | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "server_http"
    }
    service {
      name     = [[ printf "%s-server-1-serf" $region.name | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "server_serf"
    }
    service {
      name     = [[ printf "%s-server-1-rpc" $region.name | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "server_rpc"
    }
    service {
      name     = [[ printf "%s-client-1-http" $region.name | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "client_http"
    }
    service {
      name     = [[ printf "%s-client-1-serf" $region.name | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "client_serf"
    }
    service {
      name     = [[ printf "%s-client-1-rpc" $region.name | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "client_rpc"
    }
    [[ end -]]

    task "server" {
      driver = "raw_exec"

      config {
        command = [[ $packVars.nomad_binary_path | quote ]]
        args    = [
          "agent",
          "-config=local/config.hcl",
        ]
      }

      template {
        destination = "local/config.hcl"
        data        = <<EOF
data_dir     = "{{ env "NOMAD_TASK_DIR" }}/data"
name         = [[ printf "%s-server-1" $region.name | quote ]]
region       = [[ $region.name | quote ]]
enable_debug = true

server {
  authoritative_region = [[ $authRegion := index $packVars.nomad_regions 0 ]][[ $authRegion.name | quote ]]
  enabled              = true
  bootstrap_expect     = 1
}

ports {
  http = [[ $region.initial_port | quote ]]
  rpc  = [[ add 1 $region.initial_port | quote ]]
  serf = [[ add 2 $region.initial_port | quote ]]
}

[[ if $packVars.nomad_acl_bootstrap_token -]]
acl {
  enabled           = true
  replication_token = [[ $packVars.nomad_acl_bootstrap_token | quote ]]
}
[[ end -]]

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
EOF
      }
    }

    [[ if $packVars.nomad_acl_bootstrap_token ]] [[ if eq $idx 0 -]]
    task "acl_bootstrap" {

      lifecycle {
        hook    = "poststart"
        sidecar = false
      }

      driver = "raw_exec"

      config {
        command = "bash"
        args    = [
          "local/acl_bootstrap.sh",
        ]
      }

      template {
        destination = "local/acl_bootstrap.sh"
        data        = <<EOF
#!/bin/bash

echo [[ $packVars.nomad_acl_bootstrap_token ]] >> .root_token

for i in {1..20}
do
  if NOMAD_ADDR="http://127.0.0.1:[[ $region.initial_port ]]" [[ $packVars.nomad_binary_path ]] acl bootstrap -json .root_token; then
    exit 0
  else
    sleep 5
  fi
done
EOF
      }
    }
    [[- end ]][[- end ]]

    task "client" {
      driver = "raw_exec"

      config {
        command = [[ $packVars.nomad_binary_path | quote ]]
        args    = [
          "agent",
          "-config=local/config.hcl",
        ]
      }

      template {
        destination = "local/config.hcl"
        data        = <<EOF
data_dir     = "{{ env "NOMAD_TASK_DIR" }}/data"
name         = [[ printf "%s-client-1" $region.name | quote ]]
region       = [[ $region.name | quote ]]
enable_debug = true

client {
  enabled = true

  server_join {
    retry_join = [ "127.0.0.1:[[- add 1 $region.initial_port -]]" ]
  }
}

ports {
  http = [[ add 3 $region.initial_port | quote ]]
  rpc  = [[ add 4 $region.initial_port | quote ]]
  serf = [[ add 5 $region.initial_port | quote ]]
}

[[ if $packVars.nomad_acl_bootstrap_token -]]
acl {
  enabled = true
}
[[ end -]]

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
EOF
      }
    }

    [[ if $idx -]]
    task "federate" {

      lifecycle {
        hook    = "poststart"
        sidecar = false
      }

      driver = "raw_exec"

      config {
        command = "bash"
        args    = [
          "local/federate.sh",
        ]
      }

      template {
        destination = "local/federate.sh"
        data        = <<EOF
#!/bin/bash

for i in {1..20}
do
  if NOMAD_ADDR="http://127.0.0.1:[[- $region.initial_port ]]" [[ $packVars.nomad_binary_path ]] server join 127.0.0.1:[[ $authRegion := index $packVars.nomad_regions 0 ]][[ add 2 $authRegion.initial_port ]]; then
    exit 0
  else
    sleep 5
  fi
done
EOF
      }
    }
    [[- end ]]
  }
  [[- end ]]
}