resource "aws_iam_role" "eks_cluster" {
  name 			= "AWSRoleForEKS${var.name}${var.env}"
  description		= "The custom AWS role for EKS, Project = ${var.name}, Environment = ${var.env}"

  tags = "${
    map(
     "Name", "iam-role-eks-cluster-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"

  assume_role_policy 	= <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role" "eks_node_cluster" {
  name = "AWSRoleForEKSNode${var.name}${var.env}"
  description           = "The custom AWS role for EKS Nodes, Project = ${var.name}, Environment = ${var.env}"

  tags = "${
    map(
     "Name", "iam-role-eks-node-cluster-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"

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


locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks_node_cluster.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}
