resource "aws_subnet" "private_subnet" {
  count      = var.private_subnet_count * var.vpc_count
  depends_on = [aws_vpc.vpc]
  vpc_id     = aws_vpc.vpc[floor(count.index / var.private_subnet_count)].id
  cidr_block = cidrsubnet(
    element(
      var.vpc_cidr,
      floor(count.index / var.private_subnet_count)
    ),
    8,
    count.index % var.private_subnet_count + 10
  )
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Name"]}-${count.index + 1}-private-subnet"
    }
  )
}
