terraform {
  source = "git::git@github.com:miend/terraform-modules.git//vpc"
}

include {
  path = find_in_parent_folders()
}

inputs = {
}
