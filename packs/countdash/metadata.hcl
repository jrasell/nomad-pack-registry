app {
  url    = "https://github.com/hashicorp/demo-consul-101/tree/master/services"
  author = "HashiCorp"
}

pack {
  name        = "countdash"
  description = "This pack deploys countdash, an example two tier application."
  url         = "https://github.com/jrasell/nomad-pack-registry/tree/main/packs/countdash"
  version     = "0.0.1"
}
