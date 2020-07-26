terraform {
  source = "git::git@github.com:miend/terraform-modules.git//gke_node_pool"
}

dependency "gke_cluster" {
  config_path = "../gke_cluster"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private = "dummy"
  }
}

inputs = {
  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 30
  machine_type       = "n1-standard-1"
  private            = dependency.vpc.outputs.private
}

include {
  path = find_in_parent_folders()
}
