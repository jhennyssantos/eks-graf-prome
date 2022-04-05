resource "kubernetes_secret" "grafana" {
  metadata {
    name      = "grafana-${var.project}"
    namespace = var.namespace
  }

  data = {
    admin-user     = local.grafana.username
    admin-password = local.grafana.password
  }
}

resource "helm_release" "grafana" {
  chart      = "grafana"
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = var.namespace
  version    = "6.24.1"

  values = [
    templatefile("${path.module}/templates/grafana-values.yaml", {
      admin_existing_secret = kubernetes_secret.grafana.metadata[0].name
      admin_user_key        = "${local.grafana.username}"
      admin_password_key    = "${local.grafana.password}"
      prometheus_svc        = "${helm_release.prometheus.name}-server"
      replicas              = 1
    })
  ]
}