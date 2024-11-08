variable "vpc_cidr" {}
variable "subnets" {
  type = map(object({
    cidr = string
    az   = string
    name = string
    route_table = string
  }))
}