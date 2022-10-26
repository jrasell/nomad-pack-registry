The new Vault development "cluster" has now been deployed running version
[[ .vault_dev.vault_version ]].

In order to access the Vault server via the CLI, you will need to export the
following environment variables. Depending on which Nomad service provider you
are using, this section may need to populated by hand.

export VAULT_ADDR=[[ if eq .vault_dev.nomad_service_provider "nomad" ]]"http://127.0.0.1:$(nomad service info -json vault-server-http | jq '.[0].Port')"[[ end ]]
export VAULT_TOKEN="[[ .vault_dev.vault_dev_token_id ]]"
