output "gateway" {
  value       = aws_internet_gateway.internet_gateway.id
  description = "ID de la VPC creada"
}