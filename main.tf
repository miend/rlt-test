module "gke_cluster" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-cluster?ref=v0.4.3"

  name = var.cluster_name

  project  = var.project
  location = var.location
  network  = module.vpc_network.network

  # Public subnetwork instances can communicate over the internet with a Cloud NAT
  subnetwork = module.vpc_network.public_subnetwork

  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  # Makes the cluster private. Nodes have no external IP and rely on NAT configured
  # by gruntwork's vpc-network module
  enable_private_nodes = "true"

  # It would be best to disable the public endpoint and connect to the VPC via Cloud VPN.
  disable_public_endpoint = "false"

  # The networks that can access the master. This should either be restricted or unset
  # (disabled public endpoint), but it's fine for testing.
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        },
      ]
    },
  ]

  cluster_secondary_range_name = module.vpc_network.public_subnetwork_secondary_range_name

  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling

}

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "${var.cluster_name}-node-pool"
  project  = var.project
  location = var.location
  cluster  = module.gke_cluster.name

  initial_node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = var.image_type
    machine_type = var.machine_type

    tags = [
      module.vpc_network.private,
      "rlt-demo-private",
    ]

    service_account = module.gke_service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
  
  # Get cluster credentials for kubectl/helm after cluster and node pool are up
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials --region ${var.region} ${var.cluster_name}"
  }
}

module "gke_service_account" {
  source = "github.com/gruntwork-io/terraform-google-gke.git//modules/gke-service-account?ref=v0.4.3"

  name        = var.cluster_service_account_name
  project     = var.project
  description = var.cluster_service_account_description
}

# Needed to ensure the bucket backing GCR exists. google_storage_bucket_iam_member may fail
# without it.
resource "google_container_registry" "registry" {
  project  = var.project
  location = "US"
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.gke_service_account.email}"
}

module "vpc_network" {
  source = "github.com/gruntwork-io/terraform-google-network.git//modules/vpc-network?ref=v0.4.0"

  name_prefix = "${var.cluster_name}-network-${random_string.suffix.result}"
  project     = var.project
  region      = var.region

  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block
}

# Use a random suffix to prevent overlap in network names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
