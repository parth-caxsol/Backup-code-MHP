# OIDC Provider for IRSA
resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960f6f4d8be8a2f9b4eeb2b2197df9a"]
  url =  var.oidc_issuer
#   url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}