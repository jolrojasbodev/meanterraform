# Grupo de seguridad 
resource "aws_security_group" "mean_sg" {
  name        = "mean_sg"
  description = "Grupo de seguridad para la instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "Permitir trafico HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    description = "Permitir trafico HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    description = "Permitir acceso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
# Grupo de seguridad para MongoDB
resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb-sg"
  description = "Grupo de seguridad para MongoDB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Permitir trafico desde el backend"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    description = "Permitir acceso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



}

