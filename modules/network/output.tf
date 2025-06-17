output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID de la VPC creada"
}



output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "ID de la tabla de rutas pública"
}

output "public_subnet_1" {
  value       = aws_subnet.public_subnets["public_subnet_1"].id
  description = "ID de la primera subnet pública"
}

output "public_subnet_2" {
  value       = aws_subnet.public_subnets["public_subnet_2"].id
  description = "ID de la primera subnet pública"
}
output "private_subnet_id" {
  value       = aws_subnet.private_subnet.id
  description = "ID de la subnet privada"
}
output "nat_gateway_id" {
  value       = aws_nat_gateway.nat_gateway.id
  description = "ID del NAT Gateway"
}
output "nat_gateway_eip" {
  value       = aws_eip.nat_gateway_eip.id
  description = "ID del Elastic IP asociado al NAT Gateway"
}
output "nat_gateway_public_ip" {
  value       = aws_eip.nat_gateway_eip.public_ip
  description = "IP pública del NAT Gateway"
}
output "nat_gateway_private_ip" {
  value       = aws_nat_gateway.nat_gateway.private_ip
  description = "IP privada del NAT Gateway"
}


