

resource "aws_instance" "private_instances" {
  count         = var.private_subnet_count * var.ec2_count * var.vpc_count
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  subnet_id     = element(var.private_subnet_id, count.index)
  tags = merge(var.tags, {
    Name = "${var.tags.Name}-private-${count.index + 1}"
  })
}
