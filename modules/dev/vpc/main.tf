resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"

  tags = "${
    map(
     "Name", "vpc-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}
