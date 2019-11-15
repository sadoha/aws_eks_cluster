// Public
resource "aws_route_table" "rtb_public" {
  vpc_id 		= "${var.vpc}"

  route {
    cidr_block 		= "0.0.0.0/0"
    gateway_id 		= "${var.ig_gateway}"
  }

  tags = "${
    map(
     "Name", "rtb-public-${var.name}-${var.env}",
    )
  }"
}

resource "aws_route_table_association" "rta_public" {
  count 		= "2"
  subnet_id     	= "${var.subnet_public[count.index]}"
  route_table_id	= "${aws_route_table.rtb_public.id}"
}


// Private
resource "aws_route_table" "rtb_private" {
  count         	= "2"
  vpc_id                = "${var.vpc}"

  route {
    cidr_block          = "0.0.0.0/0"
    nat_gateway_id     	= "${var.nat_gateway[count.index]}"
  }

  tags = "${
    map(
     "Name", "rtb-private-${data.aws_availability_zones.available.names[count.index]}-${var.name}-${var.env}",
    )
  }"
}

resource "aws_route_table_association" "rta_private" {
  count                 = "2"
  subnet_id             = "${var.subnet_private[count.index]}"
  route_table_id        = "${aws_route_table.rtb_private[count.index].id}"
}
