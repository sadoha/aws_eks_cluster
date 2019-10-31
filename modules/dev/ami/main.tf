data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.14-v*"]
  }

  most_recent = true
  owners      = ["amazon"] # Amazon EKS AMI Account ID

  tags = "${
    map(
     "Name", "vpc-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}
