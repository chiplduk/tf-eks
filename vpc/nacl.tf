resource "aws_network_acl" "this" {
  for_each = { for nacl in var.network_acls : nacl.name => nacl }

  vpc_id = aws_vpc.this.id

  dynamic "ingress" {
    for_each = { for ingress_rule in each.value.ingress_rules : ingress_rule.rule_no => ingress_rule }

    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = try(ingress.value.from_port, null)
      to_port    = try(ingress.value.to_port, null)
    }
  }

  dynamic "egress" {
    for_each = { for egress_rule in each.value.egress_rules : egress_rule.rule_no => egress_rule }

    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = try(egress.value.from_port, null)
      to_port    = try(egress.value.to_port, null)
    }

  }

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${each.key}-nacl"
    },
    var.tags
  )
}

resource "aws_network_acl_association" "this" {
  for_each   = { for subnet in var.subnets : subnet.name => subnet }
  depends_on = [aws_network_acl.this]

  network_acl_id = aws_network_acl.this[each.value.nacl].id
  subnet_id      = aws_subnet.this[each.key].id
}