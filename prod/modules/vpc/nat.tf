
resource "aws_eip" "nat" {
  count      = var.vpc_count
  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "nat" {
  count         = var.vpc_count
  allocation_id = aws_eip.nat[count.index].id

  subnet_id = aws_subnet.public_subnet[count.index * var.public_subnet_count].id

  tags = merge(
    var.tags,
    { "Name" = "${var.tags["Name"]}-${count.index + 1}-nat" }
  )
}
