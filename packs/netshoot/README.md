# netshoot

This pack deploys a [netshoot](https://github.com/nicolaka/netshoot) job which is useful for debugging
and developing Nomad and Docker networking.

In its default configuration, the task will be run with an infinite sleep, allowing you to exec into
the container and run the available networking tools.

## Variables

- `job_name` (string "") - The name to use as the job name which overrides using the pack name.
- `datacenters` (list(string) ["dc1"]) - A list of datacenters in the region which are eligible for
  task placement.
- `region` (string "global") - The region where the job should be placed.
- `network_mode` (string "bridge") - The networking mode to use for the netshoot task.
- `mount_docker_netns` (bool false) - Should the Docker network namespaces be mounted into the
container; if so, container runs privileged.
- `netshoot_run_config` (object) - The command and additional arguments to pass to the netshoot
container.
- `netshoot_task_resources` (object) - The resource to assign to the netshoot task.

### `netshoot_run_config` Object

- `command` (string "sleep") - The command to pass to the netshoot container.
- `args` (list(string) ["infinite"]) - The arguments to pass to the command.

### `netshoot_task_resources` Object

- `cpu` (number 500) - Specifies the CPU required to run this task in MHz.
- `memory` (number 256) - Specifies the memory required in MB.
