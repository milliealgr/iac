# terraform {
#   required_version = ">= 1.5.0"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.68.0"
#     }
#   }
# }

provider "aws" {
  region = var.aws_region
}

# # Lookup the default VPC
# data "aws_vpc" "default" {
#   default = true
# }

# # Lookup subnets in the default VPC
# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# # Lookup the latest Ubuntu 24.04 LTS AMI for ARM64
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# # Security group allowing SSH and HTTP traffic
# resource "aws_security_group" "nginx_sg" {
#   name_prefix = "nginx-ec2-sg-"
#   description = "Allow SSH and HTTP inbound traffic and all outbound traffic"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     description = "SSH from anywhere"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTP from anywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTPS from anywhere"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Name        = "nginx-ec2-sg"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# # EC2 Instance with Nginx installed via user_data
# resource "aws_instance" "web" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.instance_type
#   key_name                    = var.key_name
#   vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
#   subnet_id                   = tolist(data.aws_subnets.default.ids)[0]
#   associate_public_ip_address = true

#   user_data = <<-EOF
#               #!/bin/bash
#               set -ex
#               export DEBIAN_FRONTEND=noninteractive

#               # Update packages and install Nginx
#               apt-get update -y
#               apt-get install -y nginx

#               # Start and enable Nginx service
#               systemctl enable nginx
#               systemctl restart nginx
#               EOF

#   tags = {
#     Name        = var.instance_name
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# # Previous VPC module reference kept for documentation integrity:
# # module "vpc" {
# #   source = "terraform-aws-modules/vpc/aws"
# #
# #   name = "my-vpc"
# #   cidr = "10.0.0.0/16"
# #
# #   azs             = ["us-east-2a", "us-east-2b"]
# #   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
# #   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
# #
# #   private_subnet_names = ["private-subnet-1", "private-subnet-2"]
# #   public_subnet_names  = ["public-subnet-1", "public-subnet-2"]
# #
# #   enable_nat_gateway = true
# #   # enable_vpn_gateway = true
# #
# #   igw_tags = {
# #     Name = "terraform-igw"
# #   }
# #
# #   nat_gateway_tags = {
# #     Name = "terraform-nat-gateway"
# #   }
# #
# #   tags = {
# #     Terraform   = "true"
# #     Environment = "dev"
# #   }
# # }