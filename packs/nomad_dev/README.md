# Nomad Dev
This pack deploys a single job containing a number of federated Nomad clusters.
Each cluster will contain a single server and client, with automatic
federation. This pack is for development and testing purposes only and does not
come with any guarantees.

## Requirements
The job can be triggered against a single Nomad agent running in server &
client mode using the `-dev` flag. The agent requires the following
configuration to be passed to it:
```hcl
plugin "raw_exec" {
  config {
    enabled = true
  }
}
```

## Variables

- `job_name` (string "") - The name to use as the job name.
- `datacenters` (list(string) ["dc1"]) - A list of datacenters in the region
where the Nomad job will be placed.
- `region` (string "global") - The region where the job should be placed.
- `namespace` (string "default") - The namespace where the job will be
registered.
- `nomad_binary_path` (string <required>) - The path to a local Nomad binary
used to run the Nomad tasks.
- `nomad_regions` (list(string) ["eu-west-2", "eu-central-1"]) - A list of region
identifiers to deploy. The first entry in the array will be considered
authoritative.
- `nomad_service_provider` (string "nomad") - The service provider to use for
registering services. Supports nomad, consul, or if left empty means service
registration will be skipped.
