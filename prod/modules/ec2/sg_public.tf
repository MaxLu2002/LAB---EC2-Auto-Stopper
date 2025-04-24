
resource "aws_security_group" "public_sg" {
  count       = var.vpc_count
  vpc_id      = var.vpc_id[count.index]
  name        = "${var.tags["Name"]}-public-sg"
  description = "Allow HTTP, HTTPS and SSH from anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.tags.Name}-public-sg"
  })
}
