resource "aws_subnet" "subnet_public" {
  count 			= "2"
  availability_zone 		= "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        		= "10.10.1${count.index}.0/24"
  vpc_id            		= "${var.vpc}"
  map_public_ip_on_launch       = "true"

  tags = "${
    map(
     "Name", "subnet-public-${data.aws_availability_zones.available.names[count.index]}-${var.env}-${var.name}",
    )
  }"
}

resource "aws_subnet" "subnet_private" {
  count                         = "2"
  availability_zone             = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block                    = "10.10.2${count.index}.0/24"
  vpc_id                        = "${var.vpc}"
  map_public_ip_on_launch       = "true"

  tags = "${
    map(
     "Name", "subnet-private-${data.aws_availability_zones.available.names[count.index]}-${var.env}-${var.name}",
    )
  }"
}
