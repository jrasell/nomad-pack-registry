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

variable "vault_version" {
  description = "The Vault version to run."
  type        = string
  default     = "1.12.0"
}

variable "vault_dev_token_id" {
  description = "The initial Vault root token to use."
  type        = string
}

variable "nomad_service_provider" {
  description = "The service provider to use for registering services. Supports nomad, consul, or if left empty means services registration will be skipped."
  type        = string
  default     = "nomad"
}
