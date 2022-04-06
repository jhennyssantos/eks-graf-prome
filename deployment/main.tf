provider "aws" {
  region  = var.region
  # version = "~> 4"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  required_version = ">= 1"
  backend "s3" {
    region  = "us-east-1"
    bucket  = "tfstates"
    key     = "eks_latency.tfstate"
    encrypt = true
  }
}