resource "local_file" "inventory" {
  filename = "${path.root}/../ansible/inventory/hosts"
  content = templatefile("${path.root}/templates/inventory.tpl", {
    controller_ips = module.controllers.ips,
    controller_names = module.controllers.names
  })
}
