variable "subnet_ids" {
  description = "List of public subnet IDs for the EKS cluster"
  type        = list(string)
}


variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  description = "List of EKS addons to install with their names and versions."
  default = [
    {
      name    = "vpc-cni"
      version = "v1.18.5-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.11.3-eksbuild.2"
    },
    {
      name    = "kube-proxy"
      version = "v1.31.1-eksbuild.2"
    },
    # {
    #   name    = "pod-identity"
    #   version = "v0.5.0" # Replace this with the appropriate version if needed
    # }
  ]
}