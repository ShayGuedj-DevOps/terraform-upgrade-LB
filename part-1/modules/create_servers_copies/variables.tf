variable "env" {
  type        = string
  description = "Environment name"
}

variable "old_be_instance_id" {
  type        = string
  description = "EC2 instance ID of the old BE server"
}

variable "old_fe_instance_id" {
  type        = string
  description = "EC2 instance ID of the old FE server"
}
