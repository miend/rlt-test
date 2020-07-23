variable "name" {
  default = "rlt-demo-gke"
}

variable "project" {
  default = "rlt-demo"
}

variable "region" {
  default = "us-central1"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "namespace_access_policies" {
  description = "Namespaces that should be created in the GKE cluster, along with their associated IP whitelist policies"
  type        = map(string)
  default     = {
    "production" = "0.0.0.0/0"
    "staging"    = "127.0.0.1"
  }

#  validation {
#    condition     = can(regex("CIDR-checking regex", var.namespace_access_policies.value))
#    error_message = "The namespace access policy must be valid CIDR blocks separated by commas."
#  }
}
