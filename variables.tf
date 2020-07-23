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
