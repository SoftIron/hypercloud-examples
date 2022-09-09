module "servers" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = var.k3s_servers
  name            = "k3s-server"
  cpus            = 2
  vcpus           = 4
  memory          = 8192
  ssh_key         = var.ssh_keys
  image_id        = var.hypercloud_image_id
  network_id      = var.internal_net_id
  security_groups = [0, opennebula_security_group.k3s_internal.id]
}

module "agents" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = var.k3s_agents
  name            = "k3s-agent"
  cpus            = 2
  vcpus           = 4
  memory          = 8192
  ssh_key         = var.ssh_keys
  image_id        = var.hypercloud_image_id
  network_id      = var.internal_net_id
  security_groups = [0, opennebula_security_group.k3s_internal.id]
}

module "loadbalancers" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = var.k3s_loadbalancers
  name            = "k3s-loadbalancer"
  cpus            = 1
  vcpus           = 2
  memory          = 1024
  ssh_key         = var.ssh_keys
  image_id        = var.hypercloud_image_id
  network_id      = var.public_net_id
  security_groups = [0, opennebula_security_group.k3s_public.id]
  ip              = var.public_net_ip
  second_nic      = true
  second_nic_net  = var.internal_net_id
  second_nic_sgs  = [0, opennebula_security_group.k3s_internal.id]
}
