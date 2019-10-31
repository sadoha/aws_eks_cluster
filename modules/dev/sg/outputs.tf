output "eks_cluster_id" {
  value = "${aws_security_group.eks_cluster.id}"
}

output "eks_cluster_node_id" {
  value = "${aws_security_group.eks_cluster_node.id}"
}
