The new Nomad development cluster has now been deployed. It includes [[ len .nomad_dev.nomad_regions ]]
regions named [[ .nomad_dev.nomad_regions | join ", " ]].

[[ range $idx, $region := .nomad_dev.nomad_regions -]]
The [[ $region | quote ]] Region
  Server:
    HTTP: [[ printf "127.0.0.1:5%v46" $idx | quote ]]
    RPC:  [[ printf "127.0.0.1:5%v47" $idx | quote ]]
    SERF: [[ printf "127.0.0.1:5%v48" $idx | quote ]]
  Client:
    HTTP: [[ printf "127.0.0.1:5%v56" $idx | quote ]]
    RPC:  [[ printf "127.0.0.1:5%v57" $idx | quote ]]
    SERF: [[ printf "127.0.0.1:5%v58" $idx | quote ]]

The following commands can be used to set environment variables to interact
with the [[ $region | quote ]] HTTP API:
  export NOMAD_ADDR=[[ printf "http://127.0.0.1:5%v46" $idx | quote ]]

The following link will access the [[ $region | quote ]] UI:
  http://[[ printf "127.0.0.1:5%v46" $idx ]]

[[ end ]]
