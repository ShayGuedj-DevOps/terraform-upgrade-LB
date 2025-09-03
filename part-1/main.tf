provider "aws" {
  region = "eu-central-1" # adjust to your region
}

module "upgrade_servers" {
  source = "./modules/upgrade_servers"

  env                 = var.env
  old_be_instance_id  = var.old_be_instance_id
  old_fe_instance_id  = var.old_fe_instance_id
}

