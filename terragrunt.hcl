# Configure state storage to GCS backend! 

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 0.12.7"
}

provider "google" {
  version = "~> 3.31.0"
  project = var.project
  region  = var.region
}

provider "google-beta" {
  version = "~> 3.31.0"
  project = var.project
  region  = var.region
}

provider "helm" {
  version = "~> 1.2"
}

provider "random" {
  version = "~> 2.3"
}
EOF
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "terraform-state"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east4"
    encrypt = false
  }
}

inputs {
  project     = rlt-demo
  region      = us-east4
  location    = us-east4
  chart_names = fileset(get_terragrunt_dir(), "./charts/*")
  charts_path = "${get_terragrunt_dir()}/charts"
}
