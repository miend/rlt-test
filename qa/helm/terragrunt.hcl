terraform {
  source = "git::git@github.com:miend/terraform-modules.git//helm_custom_charts"
}

inputs = {
  namespace              = "qa"
  whitelist_source_range = "0.0.0.0/0"
  host_prefix            = "qa."
  host                   = "rlt-demo.exitprompt.com"
}

include {
  path = find_in_parent_folders()
}
