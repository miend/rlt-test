terraform {
  source = "git::git@github.com:miend/terraform-modules.git//gke_cluster"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    network                                = "dummy"
    public_subnetwork                      = "dummy"
    public_subnetwork_secondary_range_name = "dummy"
  }
}

inputs = {
  network                                = dependency.vpc.outputs.network
  public_subnetwork                      = dependency.vpc.outputs.public_subnetwork
  public_subnetwork_secondary_range_name = dependency.vpc.outputs.public_subnetwork_secondary_range_name
}

include {
  path = find_in_parent_folders()
}
