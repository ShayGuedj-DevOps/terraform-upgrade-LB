variable "env" {
  description = "Environment name (e.g. v6)"
  type        = string
}

variable "old_be_instance_id" {
  description = "The EC2 instance ID of the old BE server"
  type        = string
}

variable "old_fe_instance_id" {
  description = "The EC2 instance ID of the old FE server"
  type        = string
}
