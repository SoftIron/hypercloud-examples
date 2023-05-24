variable "one_username" {}
variable "one_password" {}

variable "rke2_loadbalancers" {}
variable "rke2_servers" {}
variable "rke2_agents" {}

variable "ssh_keys" {}

variable "hypercloud_group" {}
variable "hypercloud_image_id" {}

/* Networking */

variable "internal_net_id" {}

variable "public_net_id" {}
variable "public_net_ip" {
  default     = ""
}
