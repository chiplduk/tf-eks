resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.endpoints.interface)
  depends_on = [
    aws_route_table.this,
    aws_route_table_association.public
  ]

  vpc_id              = aws_vpc.this.id
  service_name        = "${data.aws_region.current.name}.${each.key}.com.amazonaws"
  security_group_ids  = [aws_security_group.endpoints.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [for subnet in var.subnets : aws_subnet.this[subnet.name].id if length(regexall("service", subnet.name)) > 0]

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${each.key}-endpoint"
    },
    var.tags
  )
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = toset(var.endpoints.gateway)
  depends_on = [
    aws_route_table.this,
    aws_route_table_association.public
  ]

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [for route_table in var.route_tables : aws_route_table.this[route_table.name].id if length(regexall("private", route_table.name)) > 0]

  tags = merge(
    {
      "Name" = "${var.vpc_name}-${each.key}-endpoint"
    },
    var.tags
  )
}

resource "aws_security_group" "endpoints" {
  name        = "endpoints"
  description = "Allow traffic to Endpoints of VPC"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr]
    description = "Allow traffic from VPC CIDR to endpoints"
  }

  tags = merge(
    {
      "Name" = "${var.vpc_name}:endpoint"
    },
    var.tags
  )
}
