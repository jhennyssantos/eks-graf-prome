resource "aws_eks_cluster" "eks_latency_cluster" {
  name     = "cluster-${var.project}"
  role_arn = aws_iam_role.eks_latency_role.arn

  vpc_config {
    subnet_ids = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_latency_policy_attachment,
  ]
}

