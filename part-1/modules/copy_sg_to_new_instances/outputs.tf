output "new_instance_sgs" {
  description = "Security groups now attached to new instances"
  value = {
    for id in var.new_instance_ids :
    id => flatten([
      for old in data.aws_instance.old_instances : 
      old.id == id ? old.vpc_security_group_ids : []
    ])
  }
}
