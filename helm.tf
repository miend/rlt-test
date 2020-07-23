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
}

resource "helm_release" "rlt-demo" {
  for_each = toset(var.namespaces)
  name             = "rlt-demo"
  chart            = "./charts/rlt-demo"
  namespace        = each.value
  create_namespace = true
}
