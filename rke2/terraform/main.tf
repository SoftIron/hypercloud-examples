module "servers" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = var.rke2_servers
  name            = "rke2-server"
  cpus            = 2
  vcpus           = 4
  memory          = 8192
  ssh_key         = var.ssh_keys
  image_id        = var.hypercloud_image_id
  network_id      = var.internal_net_id
  security_groups = [0, opennebula_security_group.rke2_internal.id]
}

module "agents" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = var.rke2_agents
  name            = "rke2-agent"
  cpus            = 2
  vcpus           = 4
  memory          = 8192
  ssh_key         = var.ssh_keys
  image_id        = var.hypercloud_image_id
  network_id      = var.internal_net_id
  security_groups = [0, opennebula_security_group.rke2_internal.id]
}

module "loadbalancers" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = var.rke2_loadbalancers
  name            = "rke2-loadbalancer"
  cpus            = 1
  vcpus           = 2
  memory          = 1024
  ssh_key         = var.ssh_keys
  image_id        = var.hypercloud_image_id
  network_id      = var.public_net_id
  security_groups = [0, opennebula_security_group.rke2_public.id]
  ip              = var.public_net_ip
  second_nic      = true
  second_nic_net  = var.internal_net_id
  second_nic_sgs  = [0, opennebula_security_group.rke2_internal.id]
}
