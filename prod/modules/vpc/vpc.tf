resource "aws_vpc" "vpc" {
  count                = var.vpc_count
  cidr_block           = var.vpc_cidr[count.index]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { "Name" = "${var.tags["Name"]}-${count.index + 1}-vpc" }
  )
}
