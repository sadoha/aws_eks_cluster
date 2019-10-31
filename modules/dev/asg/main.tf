resource "aws_autoscaling_group" "eks_cluster" {
  desired_capacity     = "2"
  launch_configuration = "${var.launch_configuration}"
  max_size             = "2"
  min_size             = "1"
  name                 = "eks-cluster-${var.name}-${var.env}"
  vpc_zone_identifier  = "${var.subnet}"

  tag {
    key                 = "Name"
    value               = "eks-cluster-${var.name}-${var.env}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "volume"
    value               = "eks-cluster-${var.name}-${var.env}"
    propagate_at_launch = "true"
  }
}
