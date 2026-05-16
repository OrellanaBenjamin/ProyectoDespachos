provider "aws" {
  region = var.aws_region
}

# ==========================================
# 1. SECURITY GROUPS (Cortafuegos)
# ==========================================

# Security Group para el Frontend (Público)
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Permitir HTTP, HTTPS y SSH al Frontend"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Accesible desde todo Internet
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Para conectarse por consola
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group para el Backend (Privado)
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Restringir acceso solo desde el Frontend"

  # Solo permite tráfico al puerto 8080 (Spring Boot) si viene del Frontend
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  # Si tus bases de datos (MySQL) están aquí, restringimos el 3306
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    self            = true # Permite comunicación dentro del mismo grupo
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Solo para configuración (puedes restringirlo a tu IP)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==========================================
# 2. INSTANCIAS EC2
# ==========================================

# Script para instalar Docker y Docker Compose automáticamente al iniciar
locals {
  user_data_script = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y ca-certificates curl gnupg
              sudo install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              sudo chmod a+r /etc/apt/keyrings/docker.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              sudo usermod -aG docker ubuntu
              sudo systemctl enable docker
              sudo systemctl start docker
              EOF
}

# EC2 para el Frontend
resource "aws_instance" "frontend_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]

  user_data = local.user_data_script

  tags = {
    Name = "EC2-Frontend-Despachos"
  }
}

# EC2 para el Backend y BD
resource "aws_instance" "backend_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data = local.user_data_script

  tags = {
    Name = "EC2-Backend-Despachos"
  }
}


# ==========================================
# 3. AWS ECR (Registros de Imágenes Docker)
# ==========================================

# ECR para el Frontend
resource "aws_ecr_repository" "frontend_repo" {
  name                 = "despachos-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true # Escanea la imagen buscando vulnerabilidades al subirla
  }
}

# ECR para el Backend de Despachos
resource "aws_ecr_repository" "backend_despachos_repo" {
  name                 = "despachos-back-despachos"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECR para el Backend de Ventas
resource "aws_ecr_repository" "backend_ventas_repo" {
  name                 = "despachos-back-ventas"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ==========================================
# 4. AWS ECS CLUSTER (Orquestador)
# ==========================================

resource "aws_ecs_cluster" "proyecto_cluster" {
  name = "cluster-innovatech-despachos"

  setting {
    name  = "containerInsights"
    value = "enabled" # Habilita métricas de rendimiento para la defensa
  }
}