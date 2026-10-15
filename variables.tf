variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "Key2_Tarea1"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ec2-nginx"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial MariaDB database name"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Master username for MariaDB"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for MariaDB"
  type        = string
  sensitive   = true
  default     = "AdminPass123456!"
}
