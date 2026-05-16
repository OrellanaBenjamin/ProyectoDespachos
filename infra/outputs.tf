output "frontend_public_ip" {
  description = "IP pública del servidor Frontend"
  value       = aws_instance.frontend_server.public_ip
}

output "backend_private_ip" {
  description = "IP privada del servidor Backend"
  value       = aws_instance.backend_server.private_ip
}

output "backend_public_ip_ssh" {
  description = "IP pública del Backend (Úsala SOLAMENTE para conectarte por SSH a subir tu código)"
  value       = aws_instance.backend_server.public_ip
}

output "ecr_frontend_url" {
  description = "URL del repositorio ECR para el Frontend"
  value       = aws_ecr_repository.frontend_repo.repository_url
}

output "ecr_backend_despachos_url" {
  description = "URL del repositorio ECR para Backend Despachos"
  value       = aws_ecr_repository.backend_despachos_repo.repository_url
}

output "ecr_backend_ventas_url" {
  description = "URL del repositorio ECR para Backend Ventas"
  value       = aws_ecr_repository.backend_ventas_repo.repository_url
}

output "ecs_cluster_name" {
  description = "Nombre del clúster de ECS creado"
  value       = aws_ecs_cluster.proyecto_cluster.name
}