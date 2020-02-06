#
# Outputs
#

output "iam_role_nodes_arn" {
  value = aws_iam_role.nodes.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority.0.data
}

output "autoscaling_groups_name" {
  value = aws_eks_node_group.nodes.resources.*.autoscaling_groups.0.name
}


