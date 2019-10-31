resource "aws_internet_gateway" "ig" {
  vpc_id = "${var.vpc}"

  tags = "${
    map(
     "Name", "ig-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}


