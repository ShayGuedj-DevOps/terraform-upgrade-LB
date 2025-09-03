resource "aws_ami_from_instance" "BE_ami-FOR-UPGRADE" {
  name                    = "${var.env}-BE-ami-${timestamp()}"
  source_instance_id      = var.old_be_instance_id
  snapshot_without_reboot = true
}

resource "aws_ami_from_instance" "FE_ami-FOR-UPGRADE" {
  name                    = "${var.env}-FE-ami-${timestamp()}"
  source_instance_id      = var.old_fe_instance_id
  snapshot_without_reboot = true
}

# Create new BE instance
resource "aws_instance" "BE_new-FOR-UPGRADE" {
  ami           = aws_ami_from_instance.BE_ami-FOR-UPGRADE.id
  instance_type = "t3.medium" # adjust as needed

  tags = {
    Name = "${var.env}-BE-FOR-UPGRADE"
    Env  = var.env
  }
}

# Create new FE instance
resource "aws_instance" "FE_new-FOR-UPGRADE" {
  ami           = aws_ami_from_instance.FE_ami-FOR-UPGRADE.id
  instance_type = "t3.medium" # adjust as needed

  tags = {
    Name = "${var.env}-FE-FOR-UPGRADE"
    Env  = var.env
  }
}
