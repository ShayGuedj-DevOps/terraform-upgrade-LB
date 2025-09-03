data "aws_instance" "old_instances" {
  for_each    = toset(var.old_instance_ids)
  instance_id = each.value
}

locals {
  # Collect all unique security groups for each new instance
  unique_sgs_per_instance = {
    for key in keys(var.new_instance_network_interface_ids) :
    key => toset(flatten([
      for old in data.aws_instance.old_instances : old.vpc_security_group_ids
    ]))
  }

  # Flatten to a list of objects, one per unique sg/instance pair
  sg_attachments = flatten([
    for key, sgs in local.unique_sgs_per_instance : [
      for sg in sgs : {
        new_instance_key      = key
        new_network_interface = var.new_instance_network_interface_ids[key]
        sg_id                 = sg
      }
    ]
  ])
}

resource "aws_network_interface_sg_attachment" "new_instance_sgs" {
  for_each = {
    for idx, val in local.sg_attachments :
    "${val.new_instance_key}-${val.sg_id}" => val
  }
  network_interface_id = each.value.new_network_interface
  security_group_id    = each.value.sg_id
}
