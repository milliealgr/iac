# ==============================================================================
# Elastic Container Registry (ECR)
# ==============================================================================

# resource "aws_ecr_repository" "primer_proyecto_docker" {
#   name                 = "primer_proyecto_docker"
#   image_tag_mutability = "MUTABLE"
#
#   image_scanning_configuration {
#     scan_on_push = true
#   }
#
#   force_delete = true
#
#   tags = {
#     Name        = "primer_proyecto_docker"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# ==============================================================================
# Application Load Balancer (ALB)
# ==============================================================================

# resource "aws_lb" "main" {
#   name               = "ecs-app-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = data.aws_subnets.default.ids
#
#   tags = {
#     Name        = "ecs-app-alb"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# resource "aws_lb_target_group" "app" {
#   name        = "ecs-app-tg"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = data.aws_vpc.default.id
#   target_type = "ip"
#
#   health_check {
#     path                = "/"
#     protocol            = "HTTP"
#     matcher             = "200-399"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 3
#   }
#
#   tags = {
#     Name        = "ecs-app-tg"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 80
#   protocol          = "HTTP"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
# }

# ==============================================================================
# IAM Roles para ECS Task Execution
# ==============================================================================

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name_prefix = "ecsTaskExecutionRole-"
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name        = "ecs-task-execution-role"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# ==============================================================================
# CloudWatch Log Group para ECS
# ==============================================================================

# resource "aws_cloudwatch_log_group" "ecs_logs" {
#   name              = "/ecs/primer-proyecto-docker"
#   retention_in_days = 7
#
#   tags = {
#     Name        = "ecs-primer-proyecto-logs"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# ==============================================================================
# ECS Cluster, Task Definition y Service (Fargate)
# ==============================================================================

# resource "aws_ecs_cluster" "main" {
#   name = "primer-proyecto-cluster"
#
#   tags = {
#     Name        = "primer-proyecto-cluster"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# resource "aws_ecs_task_definition" "app" {
#   family                   = "primer-proyecto-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256" # Tamaño mínimo disponible en AWS Fargate (.25 vCPU)
#   memory                   = "512" # Memoria mínima disponible para 256 CPU (.5 GB)
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#
#   container_definitions = jsonencode([
#     {
#       name      = "primer-proyecto-app"
#       image     = "${aws_ecr_repository.primer_proyecto_docker.repository_url}:latest"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#           protocol      = "tcp"
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
#           "awslogs-region"        = var.aws_region
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#     }
#   ])
#
#   tags = {
#     Name        = "primer-proyecto-task"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }

# resource "aws_ecs_service" "app" {
#   name            = "primer-proyecto-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   desired_count   = 2 # Redundancia distribuida en las dos subnets
#   launch_type     = "FARGATE"
#
#   network_configuration {
#     subnets          = data.aws_subnets.default.ids
#     security_groups  = [aws_security_group.ecs_tasks_sg.id]
#     assign_public_ip = true
#   }
#
#   load_balancer {
#     target_group_arn = aws_lb_target_group.app.arn
#     container_name   = "primer-proyecto-app"
#     container_port   = 3000
#   }
#
#   depends_on = [aws_lb_listener.http]
#
#   tags = {
#     Name        = "primer-proyecto-service"
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }