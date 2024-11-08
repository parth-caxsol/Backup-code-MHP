# ALB Ingress Controller Installation using Helm and Terraform.

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}
 
data "aws_eks_cluster" "cluster" {
  name = "rp-eks-cluster"
}
 
data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

resource "aws_iam_policy" "alb_ingress_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for the ALB Ingress Controller"
  policy      = file("modules/alb-ingress/alb-ingress-policy.json")
}

resource "aws_iam_role" "alb_ingress_role" {
  name = "eks-alb-ingress-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
  role       = aws_iam_role.alb_ingress_role.name
  policy_arn = aws_iam_policy.alb_ingress_controller.arn
}

resource "kubernetes_service_account" "alb_ingress_sa" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_role.arn
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "alb_ingress_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  values = [
    <<EOF
    clusterName: "aws_eks_cluster.cluster.name"
    region: "${var.region}"
    vpcId: "${var.vpcid}"
    serviceAccount:
      create: false
      name: "alb-ingress-controller"
    EOF
  ]
}
