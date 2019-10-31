output "role_eks_cluster_arn" {
  value = "${aws_iam_role.eks_cluster.arn}"
}

output "role_eks_cluster_name" {
  value = "${aws_iam_role.eks_cluster.name}"
}

output "role_eks_node_cluster_name" {
  value = "${aws_iam_role.eks_node_cluster.name}"
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}
