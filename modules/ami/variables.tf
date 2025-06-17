# Configuración de Packer


variable "packer_template_file" {
  description = "Ruta al archivo de plantilla de Packer"
  type        = string
}

# AMI
variable "ami_name" {
  description = "Nombre base de la AMI creada por Packer"
  type        = string
}

variable "ami_name2" {
  description = "Nombre base de la AMI creada por Packer"
  type        = string
}

variable "ean_ami_id" {
  description = "ID de la AMI para el servidor web (Express/Angular/Nginx)."
  type        = string
}

variable "mongodb_ami_id" {
  description = "ID de la AMI para el servidor de base de datos (MongoDB)."
  type        = string
}
