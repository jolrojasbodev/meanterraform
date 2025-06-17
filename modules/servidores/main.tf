# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image


data "aws_ami" "nginx-nodejs" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-nodenginx"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["self"]
}

data "aws_ami" "mongodb" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ami-mongodb"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["self"]
}
# Elastic Network Interfaces (ENI) para Web Servers
resource "aws_network_interface" "web_server_eni_1" {
  count           = var.web_server_count
  subnet_id       = var.web_server_subnet_id_1
  private_ips     = [var.webserver_1_private_ip] # Asigna una IP única a cada ENI
  security_groups = [var.security_group_ids]

  tags = {
    Name = "Web-Server-ENI-1"
  }
}

resource "aws_network_interface" "web_server_eni_2" {
  count           = var.web_server_count
  subnet_id       = var.web_server_subnet_id_2
  private_ips     = [var.webserver_2_private_ip] # Asigna una IP única a cada ENI
  security_groups = [var.security_group_ids]

  tags = {
    Name = "Web-Server-ENI-2"
  }
}


resource "aws_eip" "web_server_eip_1" {
  count             = var.web_server_count
  network_interface = aws_network_interface.web_server_eni_1[count.index].id

  tags = {
    Name = "Web-Server-EIP-${count.index + 1}"
  }
}
resource "aws_eip" "web_server_eip_2" {
  count             = var.web_server_count
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
  ami           = data.aws_ami.nginx-nodejs.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web_server_eni_1[0].id
    device_index         = 0

  }


  tags = {
    Name = "nginx-nodejs"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ssh_private_key
    host        = aws_eip.web_server_eip_1[count.index].public_ip
  }

}
resource "aws_instance" "web_server_2" {
  ami           = data.aws_ami.nginx-nodejs.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.web_server_eni_2[0].id
    device_index         = 0

  }


  tags = {
    Name = "nginx-nodejs"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.ssh_private_key
    host        = aws_eip.web_server_eip_2[count.index].public_ip
  }

}

# Creacion de MongoDB

# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image

# Instancia EC2 para MongoDB
resource "aws_instance" "mongodb" {
  ami           = data.aws_ami.mongodb.id
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
