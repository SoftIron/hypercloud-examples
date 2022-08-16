variable "one_username" {}
variable "one_password" {}

variable "k3s_loadbalancers" {}
variable "k3s_controllers" {}
variable "k3s_workers" {}

variable "gitlab_user_names" {}

/* Networking */

variable "internal_net_id" {}
variable "internal_net_security_groups" {}

variable "public_net_id" {}
variable "public_net_security_groups" {}
variable "public_net_ip" {
  default     = ""
}
