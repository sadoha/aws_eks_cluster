#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "nodes" {
//  name = "nodes-${var.projectname}-${var.environment}"
  name = "AWSRoleForWorkerNodesEKS${var.projectname}${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "nodegroup-${var.projectname}-${var.environment}"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_id
  ami_type	  = "AL2_x86_64"
  disk_size	  = 20
  instance_types  = ["t3.medium"]
  release_version = "1.14.7-20190927"
  version         = "1.14"

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )

  scaling_config {
    desired_size = var.countindex 
    max_size     = var.countindex +1
    min_size     = var.countindex -1 
  }

  remote_access {
    ec2_ssh_key               = var.key_pair
    source_security_group_ids = [aws_security_group.cluster.id]
  }

  labels = {
    Type = "t3.medium"
   } 

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

