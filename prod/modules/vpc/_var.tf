# BASIC
variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

# VPC
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

variable "vpc_cidr" {
  type = list(string)
}
