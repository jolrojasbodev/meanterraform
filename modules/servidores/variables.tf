variable "ami_name" {
  type = string
}
variable "public_subnet_1" {
  type = string
}
variable "ssh_private_key" {
  description = "Clave privada SSH generada"
  type        = string
}

# Web Servers
variable "web_server_count" {
  description = "Número de instancias de servidores web"
  type        = number
  default     = 2
}
variable "web_server_subnet_id_1" {
  description = "ID de la subnet para los servidores web"
  type        = string
}

variable "web_server_subnet_id_2" {
  description = "ID de la subnet para los servidores web"
  type        = string
}

variable "web_server_private_ip_base" {
  description = "IPs privadas de los servidores web"
  type        = string
}

variable "security_group_ids" {
  description = "ID del grupo de seguridad para los servidores web"
  type        = string
}

# MongoDB
variable "mongodb_subnet_id" {
  description = "ID de la subnet para MongoDB"
  type        = string
}
variable "mongodb_private_ip" {
  description = "IP privada de MongoDB"
  type        = string
}
variable "webserver_1_private_ip" {
  description = "IP privada de webserver 1"
  type        = string
}
variable "webserver_2_private_ip" {
  description = "IP privada de webserver 2"
  type        = string
}
variable "mongodb_security_group_id" {
  description = "ID del grupo de seguridad para MongoDB"
  type        = string
}

variable "key_name" {
  description = "Nombre del par de claves SSH en AWS"
  type        = string
}

# Nuevas variables para las AMIs generadas por Packer
variable "ean_ami_id" {
  description = "ID de la AMI para el servidor web (Express/Angular/Nginx)."
  type        = string
}

variable "mongodb_ami_id" {
  description = "ID de la AMI para el servidor de base de datos (MongoDB)."
  type        = string
}