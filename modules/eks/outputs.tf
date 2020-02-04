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
