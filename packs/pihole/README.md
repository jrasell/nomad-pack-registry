# pihole

The pack deploy [Pi-hole](https://pi-hole.net/), a black hole for Internet advertisements. It runs
both the DNS interface and UI.

The job supports both Consul and Nomad service registration, the latter requires Nomad is running
version 1.3.0 or greater.

## Variables

- `job_name` (string "") - The name to use as the job name which overrides using the pack name.
- `datacenters` (list(string) ["dc1"]) - A list of datacenters in the region which are eligible for
  task placement.
- `region` (string "global") - The region where the job should be placed.
- `namespace` (string "global") - The namespace where the job should be placed.
- `dns_service_enabled` (bool true) - A boolean to control if the DNS service should be registered.
- `ui_service_enabled` (bool true) - A boolean to control if the UI service should be registered.

### `constraints` List of Objects

- `attribute` (string) - Specifies the name or reference of the attribute to examine for the
  constraint.
- `operator` (string) - Specifies the comparison operator. The ordering is compared lexically.
- `value` (string) - Specifies the value to compare the attribute against using the specified
  operation.

The default value constrains the job to run on client whose kernel name is `linux`. The HCL
variable list of objects is shown below and uses a double dollar sign for escaping:
```hcl
[
  {
    attribute = "$${attr.kernel.name}",
    value     = "linux",
    operator  = "",
  }
]
```

### `network` Object

- `mode` (string "bridge") - The mode of the network to use.
- `dns_port` (object) - The Pi-hole DNS port setup.
  - `static` (number 0) - Specifies the static TCP/UDP port to allocate. Set to `0` to omit and use
    dynamic assignment.
  - `to` (string "53") - The port to map into the container.
- `ui_port` (object) - The Pi-hole UI port setup.
  - `static` (number 0) - Specifies the static TCP/UDP port to allocate. Set to `0` to omit and use
    dynamic assignment.
  - `to` (string "80") - The port to map into the container.

The default value uses dynamic port mapping for both UI and DNS ports:
```hcl
network {
  mode = "bridge"
  port "ui" {
    to = "80"
  }
  port "dns" {
    to = "53"
  }
}
```

### `docker_config` Object

- `image` (string "pihole/pihole:2022.02.1") - The Docker image and tag to run.

### `task_resources` Object

- `cpu` (number 500) - Specifies the CPU required to run this task in MHz.
- `memory` (number 256) - Specifies the memory required in MB.

### `dns_service` Object

- `name` (string "pihole-dns") - Specifies the name this service will be advertised.
- `provider` (string "nomad") - Specifies the service registration provider to use for service
  registrations.
- `tags` (list(string) []) - Specifies the list of tags to associate with this service.

### `ui_service` Object

- `name` (string "pihole-ui") - Specifies the name this service will be advertised.
- `provider` (string "nomad") - Specifies the service registration provider to use for service
  registrations.
- `tags` (list(string) []) - Specifies the list of tags to associate with this service.
