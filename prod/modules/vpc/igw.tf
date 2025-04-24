resource "aws_internet_gateway" "igw" {
  count  = var.vpc_count
  vpc_id = aws_vpc.vpc[count.index].id

  tags = merge(
    var.tags,
    { "Name" = "${var.tags["Name"]}-${count.index + 1}-igw" }
  )
}

