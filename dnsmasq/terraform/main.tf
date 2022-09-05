module "dnsmasq" {
  source          = "../../tf-modules/tf-module-hypercloud-node"
  group_name      = var.hypercloud_group
  num             = 1
  name            = "dnsmasq"
  cpus            = 1
  vcpus           = 2
  memory          = 1024
  ssh_key         = data.http.ssh_keys.*.response_body
  image_id        = var.hypercloud_image_id
  network_id      = var.internal_net_id
  security_groups = [0, opennebula_security_group.dnsmasq_internal.id]
}
