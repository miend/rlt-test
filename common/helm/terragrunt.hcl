terraform {
  source = "git::git@github.com:miend/terraform-modules.git//helm_common"
}

inputs = {
}

include {
  path = find_in_parent_folders()
}
