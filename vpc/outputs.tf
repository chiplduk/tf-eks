output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.this.cidr_block
}

output "subnets" {
  description = "A map of subnets (subnet name => subnet ID)"
  value       = { for subnet in var.subnets : subnet.name => aws_subnet.this[subnet.name].id }
}

# output "public_subnets_ids" {
#   description = "A map of subnets (subnet name => subnet ID)"
#   value       = [ for subnet in var.subnets : aws_subnet.this[subnet.name].id ]
# }

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.this.id
}

output "nat_gateways" {
  description = "NAT Gateway ID"
  value       = [for nat_gateway in aws_nat_gateway.this : nat_gateway.id]
}

output "nat_gateway_eips" {
  description = "NAT Gateway EIP"
  value       = { for nat_gateway, eip in aws_nat_gateway.this : nat_gateway => eip.public_ip }
}

output "route_tables" {
  description = "Route table IDs of subnets"
  value       = [for route_table in aws_route_table.this : route_table.id]
}

output "vpc_peerings" {
  description = "VPC peerings IDs"
  value       = [for vpc_peering in aws_vpc_peering_connection.this : vpc_peering.id]
}
