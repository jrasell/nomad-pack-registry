job [[ template "full_job_name" . ]] {

  region      = [[ .pihole.region | quote ]]
  datacenters = [[ .pihole.datacenters | toStringList ]]
  namespace   = [[ .pihole.namespace | quote ]]
  [[ if .pihole.constraints ]][[ range $idx, $constraint := .pihole.constraints ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    value     = [[ $constraint.value | quote ]]
    [[- if ne $constraint.operator "" ]]
    operator  = [[ $constraint.operator | quote ]]
    [[- end ]]
  }
  [[- end ]][[- end ]]

  group "pihole" {

    network {
      mode = [[ .pihole.network.mode | quote ]]
      port "ui" {
      [[- if ne .pihole.network.ui_port.static 0 ]]
        static = [[ .pihole.network.ui_port.static ]]
      [[- end ]]
      [[- if ne .pihole.network.ui_port.to "" ]]
        to = [[ .pihole.network.ui_port.to | quote ]]
      [[- end ]]
      }
      port "dns" {
      [[- if ne .pihole.network.dns_port.static 0 ]]
        static = [[ .pihole.network.dns_port.static ]]
      [[- end ]]
      [[- if ne .pihole.network.dns_port.to "" ]]
        to = [[ .pihole.network.dns_port.to | quote ]]
      [[- end ]]
      }
    }

    task "pihole" {
      driver = "docker"

      config {
        image = [[ .pihole.docker_config.image | quote ]]
        ports = [ "dns", "ui" ]
      }

      resources {
        cpu    = [[ .pihole.task_resources.cpu ]]
        memory = [[ .pihole.task_resources.memory ]]
      }

      [[ if .pihole.dns_service_enabled -]]
      service {
        name     = [[ .pihole.dns_service.name | quote ]]
        port     = "dns"
        [[- if ne .pihole.dns_service.provider "" ]]
        provider = [[ .pihole.dns_service.provider | quote ]][[ end ]]
        tags     = [[ .pihole.dns_service.tags | toStringList ]]
      }
      [[- end ]]

      [[ if .pihole.ui_service_enabled -]]
      service {
        name     = [[ .pihole.ui_service.name | quote ]]
        port     = "ui"
        [[- if ne .pihole.ui_service.provider "" ]]
        provider = [[ .pihole.ui_service.provider | quote ]][[ end ]]
        tags     = [[ .pihole.ui_service.tags | toStringList ]]
      }
      [[- end ]]
    }
  }
}
