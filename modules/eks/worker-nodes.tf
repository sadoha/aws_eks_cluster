#
# EKS Worker Nodes Resources
#  * EKS Node Group to launch worker nodes
#

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "nodegroup-${var.projectname}-${var.environment}"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_id
  ami_type	  = "AL2_x86_64"
  disk_size	  = var.node_group_disk_size
  instance_types  = [var.node_group_instance_types]
  release_version = var.node_group_release_version
  version         = var.node_group_version

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
    Type = var.node_group_instance_types
  } 

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}

