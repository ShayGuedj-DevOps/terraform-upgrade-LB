output "BE_new_instance_id" {
  value = aws_instance.BE_new_for_upgrade.id
}

output "FE_new_instance_id" {
  value = aws_instance.FE_new_for_upgrade.id
}

output "be_ami_id" {
  value = aws_ami_from_instance.BE_ami.id
}

output "fe_ami_id" {
  value = aws_ami_from_instance.FE_ami.id
}

output "subnet_ids" {
  value = data.aws_instance.old_be.subnet_id != "" ? [data.aws_instance.old_be.subnet_id] : []
}

data "aws_subnet" "be_subnet" {
  id = data.aws_instance.old_be.subnet_id
}

output "vpc_id" {
  value = data.aws_subnet.be_subnet.vpc_id
}

output "BE_new_network_interface_id" {
  value = aws_instance.BE_new_for_upgrade.primary_network_interface_id
}

output "FE_new_network_interface_id" {
  value = aws_instance.FE_new_for_upgrade.primary_network_interface_id
}
