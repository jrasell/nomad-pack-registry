job [[ template "full_job_name" . ]] {

  region      = [[ .nomad_dev.region | quote ]]
  datacenters = [[ .nomad_dev.datacenters | toStringList ]]
  namespace   = [[ .nomad_dev.namespace | quote ]]

  [[ $packVars := .nomad_dev ]] [[ range $idx, $region := .nomad_dev.nomad_regions ]]

  group [[ $region | quote ]] {

    network {
      port "server_http" {
        static = [[ printf "5%v46" $idx | quote ]]
      }
      port "server_serf" {
        static = [[ printf "5%v47" $idx | quote ]]
      }
      port "server_rpc" {
        static = [[ printf "5%v48" $idx | quote ]]
      }
      port "client_http" {
        static = [[ printf "5%v56" $idx | quote ]]
      }
      port "client_serf" {
        static = [[ printf "5%v57" $idx | quote ]]
      }
      port "client_rpc" {
        static = [[ printf "5%v58" $idx | quote ]]
      }
    }

    [[ if $packVars.nomad_service_provider ]]
    service {
      name     = [[ printf "%s-server-1-http" $region | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "server_http"
    }
    service {
      name     = [[ printf "%s-server-1-serf" $region | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "server_serf"
    }
    service {
      name     = [[ printf "%s-server-1-rpc" $region | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "server_rpc"
    }
    service {
      name     = [[ printf "%s-client-1-http" $region | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "client_http"
    }
    service {
      name     = [[ printf "%s-client-1-serf" $region | quote ]]
      provider = [[ $packVars.nomad_service_provider | quote ]]
      port     = "client_serf"
    }
    service {
      name     = [[ printf "%s-client-1-rpc" $region | quote ]]
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
data_dir = "{{ env "NOMAD_TASK_DIR" }}/data"
name     = [[ printf "%s-server-1" $region | quote ]]
region   = [[ $region | quote ]]

server {
  enabled          = true
  bootstrap_expect = 1
}

ports {
  http = [[ printf "5%v46" $idx | quote ]]
  rpc  = [[ printf "5%v47" $idx | quote ]]
  serf = [[ printf "5%v48" $idx | quote ]]
}
EOF
      }
    }

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
data_dir = "{{ env "NOMAD_TASK_DIR" }}/data"
name     = [[ printf "%s-client-1" $region | quote ]]
region   = [[ $region | quote ]]

client {
  enabled = true

  server_join {
    retry_join = [ [[- printf "127.0.0.1:5%v47" $idx | quote -]] ]
  }
}

ports {
  http = [[ printf "5%v56" $idx | quote ]]
  rpc  = [[ printf "5%v57" $idx | quote ]]
  serf = [[ printf "5%v58" $idx | quote ]]
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
  if NOMAD_ADDR=[[- printf "http://127.0.0.1:5%v46" $idx | quote ]] [[ $packVars.nomad_binary_path ]] server join 127.0.0.1:5048; then
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