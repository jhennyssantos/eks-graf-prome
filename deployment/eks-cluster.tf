# resource "aws_eks_cluster" "eks_latency_cluster" {
#   name     = "cluster-${var.project}"
#   role_arn = aws_iam_role.eks_latency_role.arn
#   version  = var.version_eks

#   vpc_config {
#     subnet_ids = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_latency_policy_attachment,
#     aws_iam_role_policy_attachment.eks_service_policy_attachment,
#   ]
# }

# # Create Security Group for Cluster
# resource "aws_security_group" "sg_eks_cluster" {
#   name        = "sg-cluster-${var.project}"
#   vpc_id      = aws_vpc.vpc_eks_latency.id

#   ingress {
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#   }
#   egress {
#     from_port        = 1024
#     to_port          = 65535
#     protocol         = "tcp"
#   }

#   tags = {
#     Name = "sg-cluster-${var.project}"
#   }
# }


