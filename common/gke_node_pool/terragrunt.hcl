terraform {
  source = "git::git@github.com:miend/terraform-modules.git//gke_node_pool"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  initial_node_count = 3
  minimum_node_count = 3
  maximum_node_count = 30
  machine_type       = "n1-standard-1"
}
