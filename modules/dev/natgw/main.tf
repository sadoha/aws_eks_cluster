resource "aws_eip" "eip_nat_gateway" {
  count        	= "2"
  vpc  		= true

  tags = "${
    map(
     "Name", "eip-natgw-${data.aws_availability_zones.available.names[count.index]}-${var.name}-${var.env}",
    )
  }"
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = "2"
  allocation_id = "${aws_eip.eip_nat_gateway[count.index].id}"
  subnet_id     = "${var.subnet_public[count.index]}"

  tags = "${
    map(
     "Name", "natgw-${data.aws_availability_zones.available.names[count.index]}-${var.name}-${var.env}",
    )
  }"
}
