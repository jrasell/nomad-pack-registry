job [[ template "full_job_name" . ]] {

  region      = [[ .netshoot.region | quote ]]
  datacenters = [ [[ range $idx, $dc := .netshoot.datacenters ]][[if $idx]],[[end]][[ $dc | quote ]][[ end ]] ]
  namespace   = [[ .netshoot.namespace | quote ]]

  group "netshoot" {

    network {
      mode = [[ .netshoot.network_mode | quote ]]
    }

    task "netshoot" {
      driver = "docker"

      config {
        image   = "nicolaka/netshoot"
        command = [[ .netshoot.netshoot_run_config.command | quote ]]
        [[- if .netshoot.netshoot_run_config.args ]]
        args    = [ [[ range $idx, $arg := .netshoot.netshoot_run_config.args ]][[if $idx]],[[end]][[ $arg | quote ]][[ end ]] ]
        [[- end ]]

        [[- if .netshoot.mount_docker_netns ]]
        privileged = true
        volumes    = ["/var/run/docker/netns:/var/run/netns"]
        [[- end ]]
      }

      resources {
        cpu    = [[ .netshoot.netshoot_task_resources.cpu ]]
        memory = [[ .netshoot.netshoot_task_resources.memory ]]
      }
    }
  }
}
