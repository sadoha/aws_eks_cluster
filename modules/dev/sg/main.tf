resource "aws_security_group" "eks_cluster" {
  name        		= "eks-cluster-${var.name}-${var.env}"
  description 		= "Cluster communication with worker nodes"
  vpc_id      		= "${var.vpc}"

  egress {
    from_port   	= 0
    to_port     	= 0
    protocol    	= "-1"
    cidr_blocks 	= ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "sg-eks-cluster-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_security_group" "eks_cluster_node" {
  name        		= "eks-cluster-node-${var.name}-${var.env}"
  description 		= "Security group for all nodes in the cluster"
  vpc_id      		= "${var.vpc}"

  egress {
    from_port   	= 0
    to_port    	 	= 0
    protocol    	= "-1"
    cidr_blocks 	= ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "sg-eks-cluster-node-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "owned",
    )
  }"
}


// OPTIONAL: Allow inbound traffic from your local workstation external IP
//           to the Kubernetes. You will need to replace A.B.C.D (cidr_blocks) below with
//           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "eks_cluster_ingress_workstation_https" {
  cidr_blocks           = ["0.0.0.0/0"]
  description           = "Allow workstation to communicate with the cluster API Server"
  from_port             = "443"
  protocol              = "tcp"
  security_group_id     = "${aws_security_group.eks_cluster.id}"
  to_port               = "443"
  type                  = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = "0"
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.eks_cluster_node.id}"
  source_security_group_id = "${aws_security_group.eks_cluster_node.id}"
  to_port                  = "65535"
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = "1025"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_cluster_node.id}"
  source_security_group_id = "${aws_security_group.eks_cluster.id}"
  to_port                  = "65535"
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = "443"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.eks_cluster.id}"
  source_security_group_id = "${aws_security_group.eks_cluster_node.id}"
  to_port                  = "443"
  type                     = "ingress"
}
