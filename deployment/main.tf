provider "aws" {
  region  = var.region
  # version = "~> 4"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}