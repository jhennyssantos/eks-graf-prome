resource "random_password" "grafana" {
  length           = 24
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret" "grafana" {
   name = "grafana"
}

resource "aws_secretsmanager_secret_version" "grafanaversion" {
  secret_id = aws_secretsmanager_secret.grafana.id
  secret_string = <<EOF
   {
    "username": "${var.admin_user}",
    "password": "${random_password.grafana.result}"
   }
EOF
}

data "aws_secretsmanager_secret" "grafana" {
  arn = aws_secretsmanager_secret.grafana.arn
}
 
 
data "aws_secretsmanager_secret_version" "grafanaversion" {
  secret_id = data.aws_secretsmanager_secret.grafana.arn
}
 
 
locals {
  grafana = jsondecode(data.aws_secretsmanager_secret_version.grafanaversion.secret_string)
}