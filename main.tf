# Proveedor AWS
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source   = "./modules/network"
  vpc_name = "MEAN_vpc"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
    "public_subnet_3" = 3
  }
  gateway             = module.igw.gateway
  private_subnet_cidr = "10.0.0.0/24"
  private_subnet_az   = "us-east-1a"
  private_subnet_name = "MEAN_private_subnet"
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.network.vpc_id
}

module "security" {
  source     = "./modules/security"
  vpc_id     = module.network.vpc_id
  web_server = "MEAN_web_server"
}

module "llave" {
  source = "./modules/llave"
  name   = "MEAN_key"
}

module "ami" {
  source               = "./modules/ami"
  packer_template_file = "./packer/main.pkr.hcl"
  ami_name             = "ami-nodenginx"
  ami_name2            = "ami-mongodb"

}

module "servidores" {
  source                     = "./modules/servidores"
  ami_name                   = module.ami.ami_name
  depends_on                 = [module.ami, module.llave, module.network, module.security]
  public_subnet_1            = module.network.public_subnet_1
  ssh_private_key            = module.llave.ssh_private_key
  key_name                   = module.llave.name
  web_server_count           = 1
  web_server_subnet_id_1     = module.network.public_subnet_1
  web_server_subnet_id_2     = module.network.public_subnet_2
  web_server_private_ip_base = "10.0.101"
  mongodb_subnet_id          = module.network.private_subnet_id
  mongodb_private_ip         = "10.0.0.40"
  webserver_1_private_ip     = "10.0.101.30"
  webserver_2_private_ip     = "10.0.102.30"
  mongodb_security_group_id  = module.security.mongodb_security_group_id
  mongodb_ami                = module.ami.ami_name2
  security_group_ids         = module.security.web_server_security_group_id


}

module "load_balancer" {
  source                = "./modules/load_balancer"
  lb_name               = "app-load-balancer"                                              # módulos: load_balancer
  security_groups       = [module.security.web_server_security_group_id]                   # módulos: security, load_balancer
  subnets               = [module.network.public_subnet_1, module.network.public_subnet_2] # módulos: network, load_balancer
  vpc_id                = module.network.vpc_id                                            # módulos: network, security, instances, load_balancer
  instance_target_count = 2                                                                # módulos: load_balancer
  target_ids            = module.servidores.web_server_ids                                 # módulos: instances, load_balancer
}






