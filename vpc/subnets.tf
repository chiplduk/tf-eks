resource "aws_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = "${var.vpc_name}:${each.key}"
    },
    {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    },
    var.tags,
    each.value.tags
  )
}