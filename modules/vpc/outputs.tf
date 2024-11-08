output "subnets" {
  value = { for k, v in aws_subnet.subnets : k => v.id }
}

output "vpcid" {
  value = aws_vpc.vpc.id
}