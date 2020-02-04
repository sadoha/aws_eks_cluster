#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "eks" {
  cidr_block = "172.16.0.0/16" 

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_subnet" "eks" {
  count = var.countindex

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "172.16.${count.index}.0/24"
  vpc_id            = aws_vpc.eks.id

  tags = map(
    "Name", "eks-${data.aws_availability_zones.available.names[count.index]}-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_route_table" "eks" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_route_table_association" "eks" {
  count = var.countindex

  subnet_id      = aws_subnet.eks.*.id[count.index]
  route_table_id = aws_route_table.eks.id
}
