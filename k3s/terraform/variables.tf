variable "one_username" {}
variable "one_password" {}

variable "k3s_loadbalancers" {}
variable "k3s_servers" {}
variable "k3s_agents" {}

variable "gitlab_user_names" {}

variable "hypercloud_group" {}
variable "hypercloud_image_id" {}

/* Networking */

variable "internal_net_id" {}

variable "public_net_id" {}
variable "public_net_ip" {
  default     = ""
}
