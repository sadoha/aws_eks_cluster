#
#  EKS Cluster
#

resource "aws_eks_cluster" "cluster" {
  name     		= "cluster-${var.projectname}-${var.environment}"
  role_arn 		= aws_iam_role.cluster.arn
  version      		= "1.14"
    
  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )

  vpc_config {
    security_group_ids 		= [aws_security_group.cluster.id]
    subnet_ids         		= var.subnet_id
    endpoint_private_access 	= false
    endpoint_public_access	= true
    public_access_cidrs       	= ["0.0.0.0/0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

