terraform {
  source = "git::git@github.com:miend/terraform-modules.git//gke_cluster"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name = "rlt-demo"
}
