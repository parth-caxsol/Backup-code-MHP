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


# Fetch the existing IAM user
data "aws_iam_user" "existing_rbac_user" {
  user_name = "rbac-user" 
}

resource "aws_iam_user_policy" "rbac_user_policy" {
  name   = "rbac-user-policy"
  user   = data.aws_iam_user.existing_rbac_user.user_name  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster"
        ]
        Resource = "*"
      }
    ]
  })
}


# develop namespace full access for rbac-user

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "develop"  # Specify your desired namespace name
  }
}

resource "kubernetes_role" "develop_namespace_admin" {
  metadata {
    name      = "develop-namespace-admin"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "bind_develop_access" {
  metadata {
    name      = "bind-develop-access"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "develop-access"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.develop_namespace_admin.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = <<EOF
#     - groups:
#       - system:bootstrappers
#       - system:nodes
#       rolearn: arn:aws:iam::637423497309:role/eks-node-role
#       username: system:node:{{EC2PrivateDNSName}}
#     EOF

#     mapUsers = <<EOF
#     - userarn: arn:aws:iam::637423497309:user/rbac-user
#       username: rbac-user
#       groups:
#         - develop-access
#     EOF
#   }
# }

