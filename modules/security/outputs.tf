output "web_server_security_group_id" {
  value       = aws_security_group.mean_sg.id
  description = "ID del grupo de seguridad para los servidores web"
}

output "mongodb_security_group_id" {
  value       = aws_security_group.mongodb_sg.id
  description = "ID del grupo de seguridad para MongoDB"
}


