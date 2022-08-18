variable "name" {
  description = "Name prefix of the VMs"
}

variable "num" {
  description = "How many instances should be created"
  default     = "1"
}

variable "group_name" {
  description = "Name of the group to deploy the VM"
}

variable "cpus" {
  description = "Number of CPUs to configure on the VM"
  default     = "1"
}

variable "vcpus" {
  description = "Number of virtual CPUs to configure on the VM"
  default     = "1"
}

variable "memory" {
  description = "Ram to configure on the VM"
  default     = "1024"
}

variable "ssh_key" {
  description = "Initial ssh key to inject on the VM"
}

variable "security_groups" {
  description = "List of the security group IDs to use"
}

variable "ip" {
  description = "IP to use on the VM first nic"
  default     = ""
}

variable "image_id" {
  description = "ID of the image to use"
}

variable "network_id" {
  description = "ID of the network top use"
}

variable "second_nic" {
  description = "Boolean to attach a second nic. Needed for jump hosts or proxys."
  default     = false
}

variable "second_nic_net" {
  description = "Secondary nic network ID"
  default     = ""
}

variable "second_nic_sgs" {
  description = "Secondary nic security groups"
  default     = []
}
