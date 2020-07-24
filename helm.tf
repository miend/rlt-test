resource "google_compute_address" "ingress" {
  name    = "${var.cluster_name}-ingress-static-ip"
  project = var.project
  region  = var.region
}

resource  "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nginx-ingress" 

  set {
    name  = "controller.service.loadBalancerIP" 
    value = google_compute_address.ingress.address
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  depends_on = [
    google_container_node_pool.node_pool,
  ]
}

# There are no TLS certs configured, and those would definitely be needed for production.
# I would include steps to have Helm install cert-manager, then provision certs similar to:
# https://medium.com/google-cloud/https-with-cert-manager-on-gke-49a70985d99b

resource "helm_release" "rlt-demo" {
  for_each = var.namespaces
  name             = "rlt-demo"
  chart            = "./charts/rlt-demo"
  namespace        = each.key
  create_namespace = true

  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = each.value["whitelist_source_range"]
  }

  set {
    # Configuration for multiple hosts should be included later
    name  = "ingress.hosts[0]"
    value = "${each.value["host_prefix"]}${var.host}"
  }

  depends_on = [
    google_storage_bucket_iam_member.member,
    google_container_node_pool.node_pool,
  ]
}

# Deploy DNS records after ingress is configured
#resource "google_dns_managed_zone" "default" {
#name     = "default-zone"
#dns_name = "rlt-demo.exitprompt.com."
#}
#
#For each namespace's host_prefix value, if not empty, create a record
#resource "google_dns_record_set" "a" {
#  name         = "host_prefix.${google_dns_managed_zone.default.dns_name}"
#  managed_zone = google_dns_managed_zone.default.name
#  type         = "A"
#  ttl          = 300
#
#  rrdatas = ["${google_compute_address.ingress.address}"]
#}
