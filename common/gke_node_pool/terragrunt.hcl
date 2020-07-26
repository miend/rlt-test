terraform {
  source = "git::git@github.com:miend/terraform-modules.git//gke_node_pool"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private = "dummy"
  }
}

inputs = {
  initial_node_count = 3
  min_node_count = 3
  max_node_count = 30
  machine_type       = "n1-standard-1"
  private            = dependency.vpc.outputs.private
}

include {
  path = find_in_parent_folders()
}
