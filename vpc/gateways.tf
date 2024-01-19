resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = var.vpc_name
    },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  for_each = { for natgw in var.nat_gateways : natgw.name => natgw }

  allocation_id = aws_eip.this[each.value.eip].id
  subnet_id     = aws_subnet.this[each.value.subnet].id

  tags = merge(
    {
      "Name" = "${var.vpc_name}:${each.key}"
    },
    var.tags
  )
}