resource "aws_route_table" "this" {
  for_each = { for rt in var.route_tables : rt.name => rt }

  vpc_id = aws_vpc.this.id
  tags = merge(
    {
      "Name" = "${var.vpc_name}:${each.key}"
    },
    var.tags
  )

  dynamic "route" {
    for_each = { for route in each.value.routes : route.destination => route }

    content {
      cidr_block = route.value.destination

      gateway_id                = route.value.target_type == "igw" ? aws_internet_gateway.this.id : null
      nat_gateway_id            = route.value.target_type == "natgw" ? aws_nat_gateway.this[route.value.target].id : null
      vpc_peering_connection_id = route.value.target_type == "pcx" ? route.value.target : null
    }
  }
}

resource "aws_route_table_association" "public" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.value.route_table].id
}

