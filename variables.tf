variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster."
  type        = string
}

variable "region" {
  description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
  type        = string
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
  default     = "rlt-demo-gke"
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
  default     = "rlt-demo-gke-sa"
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
  default     = "10.5.0.0/28"
}

variable "vpc_cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.3.0.0/16"
}

variable "vpc_secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
  default     = "10.4.0.0/16"
}

variable "enable_vertical_pod_autoscaling" {
  description = "Enable vertical pod autoscaling"
  type        = string
  default     = true
}

variable "initial_node_count" {
  description = "The number of nodes the node pool should start with."
  type        = number
  default     = 1
}

variable "min_node_count" {
  description = "The minimum number of nodes in a pool, for auto-scaling purposes."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "The maximum number of nodes in a pool, for auto-scaling purposes."
  type        = number
  default     = 1
}

variable "image_type" {
  description = "The image type a node pool should use. Defaults to Container-Optimized Linux."
  type        = string
  default     = "COS"
}

variable "machine_type" {
  description = "The type of instance that a node pool should use."
  type        = string
  default     = "n1-standard-1"
}

variable "namespaces" {
  description = "Namespaces that should be created in the GKE cluster, along with their associated configurations for access whitelisting and ingress hosts."
  type = map(object({
    whitelist_source_range = string
    host_prefix            = string
  }))

  default = {
    production = {
      whitelist_source_range = "0.0.0.0/0" 
      host_prefix            = ""
    },
    staging = {
      whitelist_source_range = "127.0.0.1"
      host_prefix            = "staging."
    }
  }

# Should validate whitelist_source_range CIDR blocks
#  validation {
#    condition     = can(regex("CIDR-checking regex", value))
#    error_message = "The namespace access policy must be valid CIDR blocks separated by commas."
#  }
}

# This is used to provide a single simple host for deployed apps, sans prefixes or paths
# It should be expanded later to allow a number of hosts with varying paths in the same ingress
variable "host" {
  default = "rlt-demo.exitprompt.com"
}
