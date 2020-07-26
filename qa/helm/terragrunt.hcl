terraform {
  source = "git::git@github.com:miend/terraform-modules.git//helm"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  namespace              = "qa"
  whitelist_source_range = "0.0.0.0/0"
  host_prefix            = "qa."
  host                   = "rlt-demo.exitprompt.com"
}
