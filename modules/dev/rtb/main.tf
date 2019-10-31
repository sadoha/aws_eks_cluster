resource "aws_route_table" "rtb_public" {
  vpc_id 		= "${var.vpc}"

  route {
    cidr_block 		= "0.0.0.0/0"
    gateway_id 		= "${var.gateway}"
  }

  tags = "${
    map(
     "Name", "rtb-public-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_route_table_association" "rta_public" {
  count 		= "2"

  subnet_id     	= "${var.subnet[count.index]}"
  route_table_id	= "${aws_route_table.rtb_public.id}"
}

