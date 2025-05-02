# BASIC
region = "{YOUR-TARGET-REGION}" # "ap-northeast-1"

tags = {
  AutoStop            = "true"
  instance-state-name = "running"
  Name                = "ec2-instpector"
}

# S3
bucket_count = 2
#VPC
vpc_count            = 1
vpc_cidr             = ["10.0.0.0/16", "10.1.0.0/16"]
public_subnet_count  = 2
private_subnet_count = 2
availability_zones   = ["{YOUR-TARGET-ZONE-1}", "{YOUR-TARGET-ZONE-2}"] # ["ap-northeast-1a", "ap-northeast-1c"]
# ec2
ec2_count     = 1
instance_type = "t3.micro"
os_type       = "linux" # linux, windows, mac
