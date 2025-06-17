packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }

  }
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "ami-nodenginx"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

source "amazon-ebs" "mongodb" {
  ami_name      = "ami-mongodb"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}
# AMI para nginx y nodejs
build {
  name = "ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu",

  ]

  provisioner "file" {
    source      = "./packer/files/"
    destination = "/tmp"
  }

  provisioner "shell" {
    inline = [
      "sudo rm -r /var/lib/apt/lists/*",
      "sudo apt-get update -y",
      "sudo echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get install -y nginx",
      "sudo chmod -R 755 /var/www/html",
      "sudo cp /tmp/index.html /var/www/html/index.html",
      "sudo cp /tmp/nodejs /etc/nginx/sites-available/nodejs"
    ]
  }
  provisioner "shell" {
    inline = [
      "sudo ln -s /etc/nginx/sites-available/nodejs /etc/nginx/sites-enabled/",
      "sudo systemctl restart nginx",
      "cd ~",
      "curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh",
      "sudo bash nodesource_setup.sh",
      "sudo echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get install nodejs -y",
      "sudo echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get install build-essential -y",
      "sudo cp /tmp/hello.js /home/ubuntu/hello.js"
    ]
  }



  provisioner "shell" {
    inline = [
      "sudo npm install -y pm2@latest -g",
      "sudo pm2 start hello.js",
      "sudo pm2 startup systemd",
      "sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu",
      "sudo pm2 save",
      "sudo systemctl start pm2-ubuntu"
    ]
  }

  post-processor "shell-local" {
    inline = [
      "AMI_ID=$(aws ec2 describe-images --filters 'Name=name,Values=ami-nodenginx' --query 'Images[0].ImageId' --output text --region 'us-east-1')"
    ]

  }

}

# AMI para MongoDB
build {
  name = "mongodb"
  sources = [
    "source.amazon-ebs.mongodb",

  ]



  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get  upgrade -y",
      "sudo touch /etc/apt/sources.list.d/mongodb-org-5.0.list",
      "sudo chmod 777 /etc/apt/sources.list.d/mongodb-org-5.0.list",
      "sudo echo 'deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse' > /etc/apt/sources.list.d/mongodb-org-5.0.list",
      "sudo wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -",
      "sudo apt-get update -y",
      "sudo apt-get install -y mongodb-org",
      "sudo systemctl restart mongod",
      "sudo systemctl enable mongod"
    ]
  }



  post-processor "shell-local" {
    inline = [
      "AMI_ID2=$(aws ec2 describe-images --filters 'Name=name,Values=ami-mongodb' --query 'Images[0].ImageId' --output text --region 'us-east-1')"
    ]

  }

}


