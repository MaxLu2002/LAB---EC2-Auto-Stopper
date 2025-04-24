locals {
  arch = can(regex("(a|g)", var.instance_type)) ? "arm64" : "x86_64"
  ssm_ami_parameter_path = lookup({
    linux   = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-${local.arch}-gp2"
    windows = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-Base"
    mac     = "/aws/service/ami-amazon-macos-latest/macos-10.15"
  }, var.os_type, "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-${local.arch}-gp2")
}
data "aws_ssm_parameter" "ami" {
  name = local.ssm_ami_parameter_path
}

resource "aws_instance" "public_instances" {
  count                       = var.public_subnet_count * var.ec2_count * var.vpc_count
  ami                         = data.aws_ssm_parameter.ami.value
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_id, count.index)
  associate_public_ip_address = true
  tags = merge(var.tags, {
    Name = "${var.tags.Name}-public-${count.index + 1}"
  })
}
