provider "aws" {
    region = var.region
}

module "wordpress"{
  source = "./modules/wordpress"
  ins_type = var.ins_type
  ami = var.ami
  env = var.env
  min_size = var.min_size

  max_size = var.max_size
}

