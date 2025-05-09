module "s3" {
  source = "./modules/s3/"

  region       = var.region
  bucket_count = var.bucket_count
  tags         = var.tags
}



module "vpc" {
  source = "./modules/vpc/"

  region               = var.region
  tags                 = var.tags
  vpc_count            = var.vpc_count
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  availability_zones   = var.availability_zones
  vpc_cidr             = var.vpc_cidr
}

module "ec2" {
  source = "./modules/ec2/"

  region               = var.region
  tags                 = var.tags
  vpc_count            = var.vpc_count
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  availability_zones   = var.availability_zones
  ec2_count            = var.ec2_count
  instance_type        = var.instance_type
  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnet_id
  private_subnet_id    = module.vpc.private_subnet_id
  os_type              = var.os_type
}


