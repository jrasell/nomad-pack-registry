variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name."
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "region" {
  description = "The region where the job should be placed."
  type        = string
  default     = "global"
}

variable "namespace" {
  description = "The namespace where the job should be placed."
  type        = string
  default     = "default"
}

variable "constraints" {
  description = "Constraints to apply to the entire job."
  type        = list(object({
    attribute = string
    operator  = string
    value     = string
  }))
  default = [
    {
      attribute = "$${attr.kernel.name}",
      value     = "linux",
      operator  = "",
    },
  ]
}

variable "network" {
  description = "The Pi-hole group network configuration options."
  type        = object({
    mode     = string
    dns_port = object({
      static = number
      to     = string
    })
    ui_port = object({
      static = number
      to     = string
    })
  })
  default = {
    mode     = "bridge",
    dns_port = {
      static = 0,
      to     = "53",
    },
    ui_port = {
      static = 0,
      to     = "80",
    },
  }
}

variable "docker_config" {
  description = "The Docker config items for the Pi-hole task."
  type        = object({
    image = string
  })
  default     = {
    image = "pihole/pihole:2022.02.1",
  }
}

variable "task_resources" {
  description = "The resource to assign to the Pi-hole task."
  type        = object({
    cpu    = number
    memory = number
  })
  default      = {
    cpu    = 500,
    memory = 256,
  }
}

variable "dns_service_enabled" {
  description = "A boolean to control if the DNS service should be registered."
  type        = bool
  default     = true
}

variable "dns_service" {
  description = "The DNS service details."
  type        = object({
    name     = string
    provider = string
    tags     = list(string)
  })
  default = {
    name     = "pihole-dns",
    provider = "nomad",
    tags     = [],
  }
}

variable "ui_service_enabled" {
  description = "A boolean to control if the UI service should be registered."
  type        = bool
  default     = true
}

variable "ui_service" {
  description = "The UI service details."
  type        = object({
    name     = string
    provider = string
    tags     = list(string)
  })
  default = {
    name     = "pihole-ui",
    provider = "nomad",
    tags     = [],
  }
}
