output "ip_publica_mongodb" {
  value       = "No cuenta con una IP pública"
  description = "El servidor MongoDB no tiene una IP pública asignada"

}
output "ip_privada_mongodb" {
  value       = module.servidores.ip_privada_mongodb
  description = "IP privada del servidor MongoDB"
}
output "ip_publica_webserver_1" {
  value       = module.servidores.ip_publica_webserver_1
  description = "IP pública del primer servidor web"
}
output "ip_publica_webserver_2" {
  value       = module.servidores.ip_publica_webserver_2
  description = "IP pública del segundo servidor web"
}
output "ip_privada_webserver_1" {
  value       = module.servidores.ip_privada_webserver_1
  description = "IP privada del primer servidor web"
}
output "ip_privada_webserver_2" {
  value       = module.servidores.ip_privada_webserver_2
  description = "IP privada del segundo servidor web"
}
output "dns_name_balanceador" {
  value       = module.load_balancer.load_balancer_dns
  description = "Nombre DNS del balanceador de carga"
}
output "ip_publica_nat_gateway" {
  value       = module.network.nat_gateway_public_ip
  description = "IP pública del NAT Gateway"
}



