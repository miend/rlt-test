terraform {
  required_version = ">= 0.12.7"
# Configure state storage to GCS backend here, as:
# https://www.terraform.io/docs/backends/types/gcs.html
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
