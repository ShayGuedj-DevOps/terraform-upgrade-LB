provider "aws" {
  region = "eu-central-1" # adjust to your region
}

module "create_servers_copies" {
  source             = "./modules/create_servers_copies"
  env                = var.env
  old_be_instance_id = var.old_be_instance_id
  old_fe_instance_id = var.old_fe_instance_id
}

module "copy_sg_to_new_instances" {
  source = "./modules/copy_sg_to_new_instances"
  old_instance_ids = [
    var.old_be_instance_id,
    var.old_fe_instance_id,
  ]
  new_instance_network_interface_ids = {
    BE = module.create_servers_copies.BE_new_network_interface_id
    FE = module.create_servers_copies.FE_new_network_interface_id
  }
  new_instance_ids = [
    module.create_servers_copies.BE_new_instance_id,
    module.create_servers_copies.FE_new_instance_id,
  ]
}

data "aws_instance" "old_be" {
  instance_id = var.old_be_instance_id
}

data "aws_instance" "old_fe" {
  instance_id = var.old_fe_instance_id
}

data "aws_subnet" "be_subnet" {
  id = data.aws_instance.old_be.subnet_id
}

data "aws_subnet" "fe_subnet" {
  id = data.aws_instance.old_fe.subnet_id
}

locals {
  vpc_id     = data.aws_subnet.be_subnet.vpc_id
  subnet_ids = [data.aws_instance.old_be.subnet_id, data.aws_instance.old_fe.subnet_id]
}

module "load_balancer" {
  source = "./modules/load_balancer"
  lb_name = "${var.env}-lb"
  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids
  old_be_instance_ids = [var.old_be_instance_id]
  old_fe_instance_ids = [var.old_fe_instance_id]
  new_be_instance_ids = [module.create_servers_copies.BE_new_instance_id]
  new_fe_instance_ids = [module.create_servers_copies.FE_new_instance_id]
}
