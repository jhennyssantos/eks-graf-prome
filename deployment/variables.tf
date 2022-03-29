variable "region" {
  default = ""
  type    = string
}

variable "project" {
  default = "eks-latency"
  type    = string
}

variable "availability_zones" {
  default = 2
  type = number
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  default = 8
  type = number
}
