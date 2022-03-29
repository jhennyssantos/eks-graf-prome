# Create AWS VPC

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                           = "${var.project}-vpc",
    # "kubernetes.io/cluster/${var.project}-cluster" = "shared"
  }
}

resource "aws_subnet" "public" {
  count = var.availability_zones
  vpc_id = aws_vpc.vpc.id
}
