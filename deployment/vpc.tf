# Create AWS VPC
resource "aws_vpc" "vpc_eks_latency" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.project}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_eks_latency.id

  tags = {
    Name = "igw-${var.project}"
  }
}

#Create public subnet
resource "aws_subnet" "public" {
  count = var.availability_zones

  vpc_id            = aws_vpc.vpc_eks_latency.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true


  tags = {
    Name = "pub-az-${var.project}"
    "kubernetes.io/cluster/cluster-${var.project}" = "shared"
  }
}

# Create private subnet
resource "aws_subnet" "private" {
  count = var.availability_zones

  vpc_id            = aws_vpc.vpc_eks_latency.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index + var.availability_zones)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true


  tags = {
    Name = "pri-az-${var.project}"
    "kubernetes.io/cluster/cluster-${var.project}" = "shared"
  }
}

# Create route table public
resource "aws_route_table" "route_pub_eks_latency" {
  vpc_id = aws_vpc.vpc_eks_latency.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "rt-public-${var.project}"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "internet_access" {
  count = var.availability_zones

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.route_pub_eks_latency.id
}

# Elastic IP
resource "aws_eip" "elastic_ip_eks" {
  vpc = true

  tags = {
    Name = "eip-${var.project}"
  }
}

#NAT gateway
resource "aws_nat_gateway" "nat" {
  count = var.availability_zones
  
  allocation_id = aws_eip.elastic_ip_eks.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT-${var.project}"
  }

  depends_on = [aws_internet_gateway.gw]
}

# Add route to route table
resource "aws_route" "main" {
  route_table_id         = aws_vpc.vpc_eks_latency.default_route_table_id
  nat_gateway_id         = aws_nat_gateway.nat[0].id
  destination_cidr_block = "0.0.0.0/0"
}

# # Create route table private
# resource "aws_route_table" "route_pri_eks_latency" {
#   count = var.availability_zones
#   vpc_id = aws_vpc.vpc_eks_latency.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat[count.index].id
#   }

#   tags = {
#     Name = "rt-private-${var.project}"
#   }
# }




# Create security group for Control Plane
resource "aws_security_group" "sg_eks_control" {
  name        = "sg-control-${var.project}"
  vpc_id      = aws_vpc.vpc_eks_latency.id

  ingress {
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = flatten([cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 0), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 1), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 3)])
  }
  egress {
    from_port        = 0
    to_port          = 65535
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-control-${var.project}"
  }
}
