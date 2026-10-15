# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.web.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.web.public_ip
# }

# output "instance_public_dns" {
#   description = "Public DNS of the EC2 instance"
#   value       = aws_instance.web.public_dns
# }

# output "ssh_command" {
#   description = "Command to SSH into the instance"
#   value       = "ssh -i \"/Users/millie/Documents/IDTS/5A/Cómputo_en_la_Nube/1erParcial/${var.key_name}.pem\" ubuntu@${aws_instance.web.public_ip}"
# }

# output "nginx_url" {
#   description = "URL to access the Nginx web server"
#   value       = "http://${aws_instance.web.public_ip}"
# }

# output "rds_endpoint" {
#   description = "Connection endpoint for the MariaDB RDS instance"
#   value       = aws_db_instance.mariadb.endpoint
# }

# output "rds_address" {
#   description = "Hostname of the MariaDB RDS instance"
#   value       = aws_db_instance.mariadb.address
# }

# output "rds_port" {
#   description = "Port of the MariaDB RDS instance"
#   value       = aws_db_instance.mariadb.port
# }

# output "rds_db_name" {
#   description = "Database name of the MariaDB RDS instance"
#   value       = aws_db_instance.mariadb.db_name
# }