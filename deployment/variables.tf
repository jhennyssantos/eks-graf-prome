variable "region" {
    default = ""
    type = string
}

variable "project" {
    default = "eks-latency"
    type = string
}

variable "availability_zones" {
    default = ""
    type = number
}
