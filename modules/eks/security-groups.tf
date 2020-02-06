#
#  EC2 Security Group to allow networking traffic with EKS cluster
#

resource "aws_security_group" "cluster" {
  name        = "${var.projectname}-${var.environment}"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-ssh" {
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow SSH access to connect to nodes in cluster"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.cluster.id
  to_port           = 22
  type              = "ingress"
}
