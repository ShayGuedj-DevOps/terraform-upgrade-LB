variable "lb_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "old_be_instance_ids" {
  type = list(string)
}

variable "old_fe_instance_ids" {
  type = list(string)
}

variable "new_be_instance_ids" {
  type = list(string)
}

variable "new_fe_instance_ids" {
  type = list(string)
}
