terraform {
  source = "git::git@github.com:miend/terraform-modules.git//helm_common"
}

dependency "gke_cluster" {
  config_path = "../gke_cluster"
}

dependency "gke_node_pool" {
  config_path  = "../gke_node_pool"
  skip_outputs = true
}

inputs = {
}

include {
  path = find_in_parent_folders()
}
