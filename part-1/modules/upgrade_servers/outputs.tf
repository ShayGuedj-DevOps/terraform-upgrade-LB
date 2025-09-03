output "be_ami_id" {
  description = "The new BE AMI ID"
  value       = aws_ami_from_instance.BE_ami-FOR-UPGRADE.id
}

output "fe_ami_id" {
  description = "The new FE AMI ID"
  value       = aws_ami_from_instance.FE_ami-FOR-UPGRADE.id
}

output "be_instance_id" {
  description = "The new BE instance ID"
  value       = aws_instance.BE_new-FOR-UPGRADE.id
}

output "fe_instance_id" {
  description = "The new FE instance ID"
  value       = aws_instance.FE_new-FOR-UPGRADE.id
}

output "env" {
  description = "The environment name"
  value       = var.env
}
