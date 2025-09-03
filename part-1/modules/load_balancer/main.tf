# Data sources for old instances
data "aws_instance" "old_be" {
  instance_id = var.old_be_instance_ids[0]
}

data "aws_instance" "old_fe" {
  instance_id = var.old_fe_instance_ids[0]
}

locals {
  all_old_sgs = concat(
    tolist(data.aws_instance.old_be.vpc_security_group_ids),
    tolist(data.aws_instance.old_fe.vpc_security_group_ids)
  )

  lb_ports = ["80", "443", "4433", "4434", "4455", "3389", "1433", "5000"] # as strings
}

resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = local.all_old_sgs
  subnets            = var.subnet_ids
}

# Target group for BE
resource "aws_lb_target_group" "be" {
  name     = "${var.lb_name}-be"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Target group for FE
resource "aws_lb_target_group" "fe" {
  name     = "${var.lb_name}-fe"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Attach old BE instances
resource "aws_lb_target_group_attachment" "old_be" {
  for_each        = toset(var.old_be_instance_ids)
  target_group_arn = aws_lb_target_group.be.arn
  target_id        = each.value
  port             = 80
}

# Attach old FE instances
resource "aws_lb_target_group_attachment" "old_fe" {
  for_each        = toset(var.old_fe_instance_ids)
  target_group_arn = aws_lb_target_group.fe.arn
  target_id        = each.value
  port             = 80
}

# LB Listeners for all ports
resource "aws_lb_listener" "listeners" {
  for_each = toset(local.lb_ports)

  load_balancer_arn = aws_lb.this.arn
  port              = tonumber(each.value)
  protocol          = each.value == "80" ? "HTTP" : "TCP"

  default_action {
    type             = "forward"
    target_group_arn = each.value == "80" ? aws_lb_target_group.fe.arn : aws_lb_target_group.be.arn
  }
}
