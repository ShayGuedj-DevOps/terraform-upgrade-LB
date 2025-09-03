output "be_ami_id" {
  description = "The new BE AMI ID"
  value       = module.create_servers_copies.be_ami_id
}

output "fe_ami_id" {
  description = "The new FE AMI ID"
  value       = module.create_servers_copies.fe_ami_id
}
