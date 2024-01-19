resource "aws_vpc_peering_connection" "this" {
  for_each = { for pcx in var.vpc_peering : pcx.pcx_name => pcx }

  peer_owner_id = each.value.peer_account_id
  peer_vpc_id   = each.value.peer_vpc_id
  vpc_id        = aws_vpc.this.id

  auto_accept = false

  tags = merge(
    {
      "Name" = "${var.vpc_name}:${each.key}"
    },
    var.tags
  )
}
