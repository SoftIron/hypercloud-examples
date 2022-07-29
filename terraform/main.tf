module "controllers" {
  source          = "./modules/tf-module-hypercloud-node"
  group_name      = "SoftIron PE"
  num             = var.k3s_controllers
  name            = "k3s_controller"
  cpus            = 1
  vcpus           = 2
  memory          = 1024
  ssh_key         = var.k3s_ssh-key
  image_id        = 26
  network_id      = 2
  security_groups = [0, 101]
}
