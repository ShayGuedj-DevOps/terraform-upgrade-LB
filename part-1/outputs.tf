output "be_ami_id" {
  description = "The new BE AMI ID"
  value       = module.upgrade_servers.be_ami_id
}

output "fe_ami_id" {
  description = "The new FE AMI ID"
  value       = module.upgrade_servers.fe_ami_id
}
