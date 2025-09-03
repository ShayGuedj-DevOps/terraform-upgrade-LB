##############################
# Data sources: old instances
##############################

data "aws_instance" "old_be" {
  instance_id = var.old_be_instance_id
}

data "aws_instance" "old_fe" {
  instance_id = var.old_fe_instance_id
}

data "aws_ebs_volumes" "BE_volumes" {
  filter {
    name   = "attachment.instance-id"
    values = [var.old_be_instance_id]
  }
}

data "aws_ebs_volumes" "FE_volumes" {
  filter {
    name   = "attachment.instance-id"
    values = [var.old_fe_instance_id]
  }
}

##############################
# AMIs from old servers
##############################

resource "aws_ami_from_instance" "BE_ami" {
  name                    = "${var.env}-BE-ami-${timestamp()}"
  source_instance_id      = var.old_be_instance_id
  snapshot_without_reboot = true
}

resource "aws_ami_from_instance" "FE_ami" {
  name                    = "${var.env}-FE-ami-${timestamp()}"
  source_instance_id      = var.old_fe_instance_id
  snapshot_without_reboot = true
}

##############################
# New instances
##############################

resource "aws_instance" "BE_new_for_upgrade" {
  ami           = aws_ami_from_instance.BE_ami.id
  instance_type = "t3.medium"
  tags = {
    Name = "${var.env}-BE-FOR-UPGRADE"
    Env  = var.env
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_instance" "FE_new_for_upgrade" {
  ami           = aws_ami_from_instance.FE_ami.id
  instance_type = "t3.medium"
  tags = {
    Name = "${var.env}-FE-FOR-UPGRADE"
    Env  = var.env
  }
  lifecycle {
    prevent_destroy = true
  }
}

##############################
# Local values for root volumes
##############################

locals {
  old_be_root_volume_id = tolist(data.aws_instance.old_be.root_block_device)[0].volume_id
  old_fe_root_volume_id = tolist(data.aws_instance.old_fe.root_block_device)[0].volume_id

  BE_non_root_volumes = [
    for vol in data.aws_ebs_volumes.BE_volumes.ids : vol
    if vol != local.old_be_root_volume_id
  ]

  FE_non_root_volumes = [
    for vol in data.aws_ebs_volumes.FE_volumes.ids : vol
    if vol != local.old_fe_root_volume_id
  ]
}

##############################
# Create snapshots of non-root volumes
##############################

resource "aws_ebs_snapshot" "BE_snapshots" {
  for_each  = toset(local.BE_non_root_volumes)
  volume_id = each.value
}

resource "aws_ebs_snapshot" "FE_snapshots" {
  for_each  = toset(local.FE_non_root_volumes)
  volume_id = each.value
}

##############################
# Create new EBS volumes from snapshots
##############################

resource "aws_ebs_volume" "BE_new_volumes" {
  for_each          = aws_ebs_snapshot.BE_snapshots
  availability_zone = aws_instance.BE_new_for_upgrade.availability_zone
  snapshot_id       = each.value.id
}

resource "aws_ebs_volume" "FE_new_volumes" {
  for_each          = aws_ebs_snapshot.FE_snapshots
  availability_zone = aws_instance.FE_new_for_upgrade.availability_zone
  snapshot_id       = each.value.id
}

##############################
# Attach new EBS volumes to new instances
##############################

resource "aws_volume_attachment" "BE_attach" {
  for_each    = aws_ebs_volume.BE_new_volumes
  device_name = "/dev/sdf"
  volume_id   = each.value.id
  instance_id = aws_instance.BE_new_for_upgrade.id
}

resource "aws_volume_attachment" "FE_attach" {
  for_each    = aws_ebs_volume.FE_new_volumes
  device_name = "/dev/sdf"
  volume_id   = each.value.id
  instance_id = aws_instance.FE_new_for_upgrade.id
}
