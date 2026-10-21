# ==============================================================================
# Elastic Container Registry (ECR)
# ==============================================================================

resource "aws_ecr_repository" "primer_proyecto_docker" {
  name                 = "primer_proyecto_docker"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true

  tags = {
    Name        = "primer_proyecto_docker"
    Environment = "dev"
    Terraform   = "true"
  }
}
