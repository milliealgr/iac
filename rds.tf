# ==============================================================================
# Private Subnets for Database
# ==============================================================================

# # Private Subnet in Availability Zone A
# resource "aws_subnet" "private_1" {
#   vpc_id            = data.aws_vpc.default.id
#   cidr_block        = "172.31.32.0/20"
#   availability_zone = "us-east-2a"
#
#   map_public_ip_on_launch = false
#
#   tags = {
#     Name        = "private-subnet-1"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# # Private Subnet in Availability Zone B
# resource "aws_subnet" "private_2" {
#   vpc_id            = data.aws_vpc.default.id
#   cidr_block        = "172.31.48.0/20"
#   availability_zone = "us-east-2b"
#
#   map_public_ip_on_launch = false
#
#   tags = {
#     Name        = "private-subnet-2"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# # Dedicated Private Route Table without Internet Gateway route
# resource "aws_route_table" "private" {
#   vpc_id = data.aws_vpc.default.id
#
#   tags = {
#     Name        = "private-route-table"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# # Associate private subnets with the private route table
# resource "aws_route_table_association" "private_1" {
#   subnet_id      = aws_subnet.private_1.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_2" {
#   subnet_id      = aws_subnet.private_2.id
#   route_table_id = aws_route_table.private.id
# }

# ==============================================================================
# DB Subnet Group (spans at least two AZs in private subnets)
# ==============================================================================

# resource "aws_db_subnet_group" "mariadb_subnet_group" {
#   name        = "mariadb-private-subnet-group"
#   description = "DB Subnet Group spanning private subnets for MariaDB"
#   subnet_ids  = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#
#   tags = {
#     Name        = "mariadb-private-subnet-group"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# ==============================================================================
# MariaDB Security Group
# ==============================================================================

# resource "aws_security_group" "mariadb_sg" {
#   name_prefix = "mariadb-rds-sg-"
#   description = "Allow MariaDB 3306 inbound from EC2 web instance"
#   vpc_id      = data.aws_vpc.default.id
#
#   ingress {
#     description     = "MariaDB port 3306 from EC2 instance"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.nginx_sg.id]
#   }
#
#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   lifecycle {
#     create_before_destroy = true
#   }
#
#   tags = {
#     Name        = "mariadb-rds-sg"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# ==============================================================================
# MariaDB RDS Instance
# ==============================================================================

# resource "aws_db_instance" "mariadb" {
#   identifier             = "mariadb-instance"
#   engine                 = "mariadb"
#   engine_version         = "10.11"
#   instance_class         = var.db_instance_class
#   allocated_storage      = 20
#   max_allocated_storage  = 100
#   storage_type           = "gp3"
#   db_name                = var.db_name
#   username               = var.db_username
#   password               = var.db_password
#   db_subnet_group_name   = aws_db_subnet_group.mariadb_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.mariadb_sg.id]
#   publicly_accessible    = false
#   skip_final_snapshot    = true
#
#   tags = {
#     Name        = "mariadb-instance"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }