resource "google_compute_address" "ingress" {
  name    = "${var.name}-ingress-static-ip"
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

}

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
}
