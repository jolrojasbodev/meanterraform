# modules/ami/main.tf

resource "null_resource" "packer_ami_ean" {
  triggers = {
    build_id = timestamp()
  }

  provisioner "local-exec" {
    command     = "packer build -machine-readable -force ${path.module}/../../packer/eanpacker.json | tee packer_ean_output.txt"
    working_dir = "${path.module}/../../"
  }

  provisioner "local-exec" {
    when        = create
    command     = "tail -1 packer_ean_output.txt | grep 'ami-' | awk '{print $NF}' > ean_ami_id.txt"
    working_dir = "${path.module}/../../"
  }
}

resource "null_resource" "packer_ami_mongo" {
  triggers = {
    build_id = timestamp()
  }

  provisioner "local-exec" {
    command     = "packer build -machine-readable -force ${path.module}/../../packer/mongopacker.json | tee packer_mongo_output.txt"
    working_dir = "${path.module}/../../"
  }

  provisioner "local-exec" {
    when        = create
    command     = "tail -1 packer_mongo_output.txt | grep 'ami-' | awk '{print $NF}' > mongo_ami_id.txt"
    working_dir = "${path.module}/../../"
  }
}

data "local_file" "ean_ami_id" {
  filename   = "${path.module}/../../ean_ami_id.txt"
  depends_on = [null_resource.packer_ami_ean]
}

data "local_file" "mongo_ami_id" {
  filename   = "${path.module}/../../mongo_ami_id.txt"
  depends_on = [null_resource.packer_ami_mongo]
}