resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.eks_latency_cluster.name
  node_group_name = "cluster-${var.project}"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = aws_subnet.private[*].id

  ami_type = var.ami_type
  capacity_type = var.capacity_type
  instance_types = ["t2.medium"]
  disk_size = var.disk_size

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Create security group for workers
resource "aws_security_group" "sg_eks_worker" {
  name        = "sg-worker-${var.project}"
  vpc_id      = aws_vpc.vpc_eks_latency.id

  ingress {
    description      = "Comunicacao entre os nos"
    from_port        = 0
    to_port          = 65535
    protocol         = "-1"
    cidr_blocks      = flatten([cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 0), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 1), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 3)])
  }

   ingress {
    description      = "Comunicacao com o plano de controle do cluster"
    from_port        = 1025
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = flatten([cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, 3)])
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-worker-${var.project}"
  }
}