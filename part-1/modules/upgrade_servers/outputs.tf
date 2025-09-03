output "be_ami_id" {
  description = "The new BE AMI ID"
  value       = aws_ami_from_instance.be_ami.id
}

output "fe_ami_id" {
  description = "The new FE AMI ID"
  value       = aws_ami_from_instance.fe_ami.id
}

output "be_instance_id" {
  description = "The new BE instance ID"
  value       = aws_instance.be_new.id
}

output "fe_instance_id" {
  description = "The new FE instance ID"
  value       = aws_instance.fe_new.id
}

