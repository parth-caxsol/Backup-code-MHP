# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Subnets as a map (public and private)
variable "subnets" {
  description = "Map of subnets with CIDR block, availability zone, and names"
  type = map(object({
    cidr         = string
    az           = string
    name         = string
    route_table  = string
  }))
}

variable "region" {}
