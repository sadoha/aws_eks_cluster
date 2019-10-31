output "eks_cluster_id" {
  value = "${aws_launch_configuration.eks_cluster.id}"
}
