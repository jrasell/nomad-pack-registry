# Vault Dev
This pack deploys a single Vault server running in dev mode. This pack is for
development and testing purposes only and does not come with any guarantees.

## Variables

- `job_name` `(string "")` - The name to use as the job name.
- `datacenters` `(list(string) ["dc1"])` - A list of datacenters in the region
where the Nomad job will be placed.
- `region` `(string "global")` - The region where the job should be placed.
- `namespace` `(string "default")` - The namespace where the job will be
registered.
- `vault_version` `(string "1.12.0")` - The Vault version to run.
- `vault_dev_token_id` `(string <required>)` - The initial root token to use.
- `nomad_service_provider` `(string "nomad")` - The service provider to use for
registering services. Supports nomad, consul, or if left empty means service
registration will be skipped.
