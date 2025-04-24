resource "aws_route_table" "public" {
  count  = var.vpc_count
  vpc_id = aws_vpc.vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.tags["Name"]}-${count.index + 1}-vpc-public-route-table"
    }
  )
}

locals {
  public_associations = {
    for assoc in flatten([
      for vpc_index in range(var.vpc_count) : [
        for az_index in range(var.public_subnet_count) : {
          key            = "${vpc_index}-${az_index}"
          subnet_id      = aws_subnet.public_subnet[vpc_index * var.public_subnet_count + az_index].id
          route_table_id = aws_route_table.public[vpc_index].id
        }
      ]
      ]) : assoc.key => {
      subnet_id      = assoc.subnet_id
      route_table_id = assoc.route_table_id
    }
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_associations

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id

  depends_on = [aws_route_table.public]
}




