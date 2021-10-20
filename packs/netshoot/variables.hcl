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

variable "network_mode" {
  description = "The network mode to run the netshoot task."
  type        = string
  default     = "bridge"
}

variable "mount_docker_netns" {
  description = "Should the Docker network namespaces be mounted into the container; if so, container runs privileged."
  type        = bool
  default     = false
}

variable "netshoot_run_config" {
  description = "The command and additional arguments to pass to the netshoot container."
  type        = object({
    command = string
    args    = list(string)
  })
  default      = {
    command = "sleep",
    args    = ["infinite"],
  }
}

variable "netshoot_task_resources" {
  description = "The resource to assign to the netshoot task."
  type        = object({
    cpu    = number
    memory = number
  })
  default      = {
    cpu    = 500,
    memory = 256,
  }
}
