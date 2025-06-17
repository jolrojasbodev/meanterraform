# Elastic Network Interfaces (ENI) para Web Servers
resource "aws_network_interface" "web_server_eni_1" {
  count           = var.web_server_count
  subnet_id       = var.web_server_subnet_id_1
  private_ips     = [var.webserver_1_private_ip]
  security_groups = [var.security_group_ids]

  tags = {
    Name = "Web-Server-ENI-1"
  }
}

resource "aws_network_interface" "web_server_eni_2" {
  count           = var.web_server_count
  subnet_id       = var.web_server_subnet_id_2
  private_ips     = [var.webserver_2_private_ip]
  security_groups = [var.security_group_ids]

  tags = {
    Name = "Web-Server-ENI-2"
  }
}


resource "aws_eip" "web_server_eip_1" {
  count           = var.web_server_count
  network_interface = aws_network_interface.web_server_eni_1[count.index].id

  tags = {
    Name = "Web-Server-EIP-${count.index + 1}"
  }
}
resource "aws_eip" "web_server_eip_2" {
  count           = var.web_server_count
  network_interface = aws_network_interface.web_server_eni_2[count.index].id

  tags = {
    Name = "Web-Server-EIP-${count.index + 1}"
  }
}

# Elastic Network Interface (ENI) para MongoDB
resource "aws_network_interface" "mongodb_eni" {
  subnet_id       = var.mongodb_subnet_id
  private_ips     = [var.mongodb_private_ip]
  security_groups = [var.mongodb_security_group_id]

  tags = {
    Name = "MongoDB-ENI"
  }
}


# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server_1" {
  ami           = var.ean_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web_server_eni_1[0].id
    device_index         = 0
  }

  tags = {
    Name = "nginx-nodejs"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "MONGO_DB_HOST=${aws_instance.mongodb.private_ip}" >> /etc/environment
              . /etc/environment
              EOF

  depends_on = [
    aws_instance.mongodb
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ssh_private_key
    host        = aws_eip.web_server_eip_1[0].public_ip
  }
}

resource "aws_instance" "web_server_2" {
  ami           = var.ean_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web_server_eni_2[0].id
    device_index         = 0
  }

  tags = {
    Name = "nginx-nodejs"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "MONGO_DB_HOST=${aws_instance.mongodb.private_ip}" >> /etc/environment
              . /etc/environment
              EOF

  depends_on = [
    aws_instance.mongodb
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ssh_private_key
    host        = aws_eip.web_server_eip_2[0].public_ip
  }
}

# Creacion de MongoDB
resource "aws_instance" "mongodb" {
  ami           = var.mongodb_ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.mongodb_eni.id
    device_index         = 0
  }

  tags = {
    Name = "MongoDB-Instance"
  }
}