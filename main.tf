module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  subnets         = var.subnets 
}

module "eks" {
  source     = "./modules/eks"
  subnet_ids = [for key, value in module.vpc.subnets : value if var.subnets[key].route_table == "public"]
  depends_on = [module.vpc]
}

module "rbac" {
  source     = "./modules/rbac"
}

module "oidc" {
  source     = "./modules/oidc"
  oidc_issuer = module.eks.oidc_issuer
}

module "alb-ingress" {
  source     = "./modules/alb-ingress"
  vpcid = module.vpc.vpcid
  region = var.region
}

