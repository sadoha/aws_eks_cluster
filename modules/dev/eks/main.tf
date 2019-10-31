// The below is an example IAM role and policy to allow the worker nodes to 
// manage or retrieve data from other AWS services. It is used by Kubernetes 
// to allow worker nodes to join the cluster.

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role                  = "${var.iam_role_name}"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn            = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role                  = "${var.iam_role_name}"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn 		= "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       		= "${var.iam_role_node_name}"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn 		= "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       		= "${var.iam_role_node_name}"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn 		= "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       		= "${var.iam_role_node_name}"
}

// This resource is the actual Kubernetes master cluster. It can take a few minutes
//  to provision in AWS.

resource "aws_eks_cluster" "eks_cluster" {
  name            	= "eks-${var.name}-${var.env}"
  role_arn        	= "${var.iam_role_arn}"

  vpc_config {
    security_group_ids 	= ["${var.security_group}"]
    subnet_ids         	= "${var.subnet}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy",
  ]

  tags = "${
    map(
     "Name", "eks-${var.name}-${var.env}",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

