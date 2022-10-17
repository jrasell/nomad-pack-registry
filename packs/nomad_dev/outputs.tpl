The new Nomad development cluster has now been deployed and includes [[ len .nomad_dev.nomad_regions ]]
regions.

[[ $packVars := .nomad_dev ]] [[ range $idx, $region := .nomad_dev.nomad_regions -]]
The [[ $region.name | quote ]] Region
  Server:
    HTTP: "127.0.0.1:[[ $region.initial_port ]]"
    RPC:  "127.0.0.1:[[ add 1 $region.initial_port ]]"
    SERF: "127.0.0.1:[[ add 2 $region.initial_port ]]"
  Client:
    HTTP: "127.0.0.1:[[ add 3 $region.initial_port ]]"
    RPC:  "127.0.0.1:[[ add 4 $region.initial_port ]]"
    SERF: "127.0.0.1:[[ add 5 $region.initial_port ]]"

The following commands can be used to set environment variables to interact
with the [[ $region.name | quote ]] HTTP API:
  export NOMAD_ADDR="http://127.0.0.1:[[ $region.initial_port ]]"
  [[- if $packVars.nomad_acl_bootstrap_token ]]export NOMAD_TOKEN=[[ $packVars.nomad_acl_bootstrap_token | quote ]][[ end ]]

The following link will access the [[ $region.name | quote ]] UI:
  http://127.0.0.1:[[ $region.initial_port ]]

[[ end -]]
