terraform {
  source = "git::git@github.com:miend/terraform-modules.git//helm_custom_charts"
}

dependency "gke_cluster" {
  config_path = "../../common/gke_cluster"
}

dependency "gke_node_pool" {
  config_path  = "../../common/gke_node_pool"
  skip_outputs = true
}

inputs = {
  namespace              = "production"
  whitelist_source_range = "0.0.0.0/0"
  host_prefix            = ""
  host                   = "rlt-demo.exitprompt.com"
}

include {
  path = find_in_parent_folders()
}
