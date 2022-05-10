variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement."
  type        = list(string)
  default     = ["dc1"]
}

variable "region" {
  description = "The region where the jobs should be placed."
  type        = string
  default     = "global"
}

variable "namespace" {
  description = "The namespace where the jobs should be placed."
  type        = string
  default     = "default"
}

variable "network_mode" {
  description = "The networking mode to use for both the api and ui jobs."
  type        = string
  default     = "bridge"
}

variable "service_provider" {
  description = "The service provider where the service registration will be performed. Supports consul or nomad."
  type        = string
  default     = "nomad"
}
