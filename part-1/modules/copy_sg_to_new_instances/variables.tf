variable "old_instance_ids" {
  type        = list(string)
  description = "Old instance IDs to copy SGs from"
}

variable "new_instance_network_interface_ids" {
  type        = map(string)
  description = "Map of new instance keys to their primary network interface IDs"
}

variable "new_instance_ids" {
  description = "List of new instance IDs"
  type        = list(string)
}

