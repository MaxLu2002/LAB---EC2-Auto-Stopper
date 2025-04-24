# BASIC
region = "ap-northeast-2"
tags   = { Name = "max-test" }
# S3
bucket_count = 2
#VPC
vpc_count            = 1
vpc_cidr             = ["10.0.0.0/16", "10.1.0.0/16"]
public_subnet_count  = 1
private_subnet_count = 1
availability_zones   = ["ap-northeast-2a", "ap-northeast-2b"]
# ec2
ec2_count     = 1
instance_type = "t3.micro"
os_type       = "linux" # linux, windows, mac
