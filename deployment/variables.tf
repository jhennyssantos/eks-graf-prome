variable "region" {
  default = ""
  type    = string
}

variable "project" {
  default = "eks-latency"
  type    = string
}

variable "availability_zones" {
  default = 3
  type = number
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  default = 8
  type = number
}

variable "version_eks" {
    default = 1.21
    type = number
}

variable "ami_type" {
    default = "AL2_x86_64"
    type = string 
}

variable "capacity_type" {
    default = "ON_DEMAND"
    type = string
}

variable "disk_size" {
    default = 30
    type = number
}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "admin_user" {
  type    = string
  default = "admin"
}

variable "service_account" {
  description = "Name of the Service Account for Grafana"
  type        = string
  default     = ""
}

variable "pdb" {
  description = "PodDisruptionBudget for Grafana"
  type        = map(any)
  default = {
    minAvailable = 1
  }
}