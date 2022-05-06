# countdash

This pack deploys [countdash](https://github.com/hashicorp/demo-consul-101/tree/master/services),
an example two tier application which is ideal for demoing service discovery.

The application includes an API which counts the number of requests it receives, and a UI which
presents this information in a nice manner. The UI must be able to discover and connect to the
backend API in order to work correctly.

## Variables

- `datacenters` (list(string) ["dc1"]) - A list of datacenters in the region which are eligible for
  task placement.
- `region` (string "global") - The region where the job should be placed.
- `namespace` (string "default") - The namespace where the jobs should be placed.
- `network_mode` (string "bridge") - The networking mode to use for both the api and ui jobs.
- `service_provider` (string "nomad") - The service provider where the service registration will be
performed. Supports consul or nomad.
