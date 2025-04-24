variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_count" {
  type = number
}

variable "public_subnet_count" {
  type = number
}

variable "private_subnet_count" {
  type = number
}

variable "availability_zones" {
  type = list(string)
}

variable "ec2_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "public_subnet_id" {
  type = list(string)
}

variable "private_subnet_id" {
  type = list(string)
}

variable "vpc_id" {
  type = list(string)
}

variable "os_type" {
  type = string
}
