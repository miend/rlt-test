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

variable "namespaces" {
  description = "Namespaces that should be created in the GKE cluster"
  type        = list(string)
  default     = ["production", "staging"]
}
