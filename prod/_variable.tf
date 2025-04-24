# BASIC
variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

# S3
variable "bucket_count" {
  type = number
}

# VPC
variable "vpc_count" {
  type = number
}

variable "vpc_cidr" {
  type = list(string)
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

# EC2
variable "ec2_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "os_type" {
  type = string
}


