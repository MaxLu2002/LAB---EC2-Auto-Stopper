resource "aws_route_table" "private" {
  count  = var.vpc_count
  vpc_id = aws_vpc.vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Name"]}-${count.index + 1}-vpc-private-route-table"
    }
  )
}

locals {
  private_associations = {
    for assoc in flatten([
      for vpc_index in range(var.vpc_count) : [
        for az_index in range(var.private_subnet_count) : {
          key            = "${vpc_index}-${az_index}"
          subnet_id      = aws_subnet.private_subnet[vpc_index * var.private_subnet_count + az_index].id
          route_table_id = aws_route_table.private[vpc_index].id
        }
      ]
      ]) : assoc.key => {
      subnet_id      = assoc.subnet_id
      route_table_id = assoc.route_table_id
    }
  }
}

resource "aws_route_table_association" "private" {
  for_each = local.private_associations

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id

  depends_on = [aws_route_table.private]
}




