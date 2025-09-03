resource "aws_ami_from_instance" "be_ami" {
  name                    = "${var.env}-BE-ami-${timestamp()}"
  source_instance_id      = var.old_be_instance_id
  snapshot_without_reboot = true
}

resource "aws_ami_from_instance" "fe_ami" {
  name                    = "${var.env}-FE-ami-${timestamp()}"
  source_instance_id      = var.old_fe_instance_id
  snapshot_without_reboot = true
}

# Create new BE instance
resource "aws_instance" "be_new" {
  ami           = aws_ami_from_instance.be_ami.id
  instance_type = "t3.medium" # adjust as needed
  tags = {
    Name = "${var.env}-BE-02"
  }
}

# Create new FE instance
resource "aws_instance" "fe_new" {
  ami           = aws_ami_from_instance.fe_ami.id
  instance_type = "t3.medium" # adjust as needed
  tags = {
    Name = "${var.env}-FE-02"
  }
}

