# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"
#
#   name = "my-vpc"
#   cidr = "10.0.0.0/16"
#
#   azs             = ["us-east-2a", "us-east-2b"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
#
#   private_subnet_names = ["private-subnet-1", "private-subnet-2"]
#   public_subnet_names  = ["public-subnet-1", "public-subnet-2"]
#
#   enable_nat_gateway = true
#   # enable_vpn_gateway = true
#
#   igw_tags = {
#     Name = "terraform-igw"
#   }
#
#   nat_gateway_tags = {
#     Name = "terraform-nat-gateway"
#   }
#
#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }