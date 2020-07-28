locals {
  project  = "rlt-demo"
  region   = "us-east4"
  location = "us-east4"
}

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
    bucket   = "miend-terraform-state"
    prefix   = "terraform/state"
    project  = local.project
    location = local.location
  }
}

inputs = {
  project      = local.project
  region       = local.region
  location     = local.location
  cluster_name = "rlt-demo"
  chart_names  = fileset("${get_terragrunt_dir()}/../../charts", "*")
  charts_path  = "${get_terragrunt_dir()}/../../charts"
}
