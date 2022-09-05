resource "local_file" "inventory" {
  filename = "${path.root}/../ansible/inventory/hosts"
  content = templatefile("${path.root}/templates/inventory.tpl", {
    dnsmasq_ips = module.dnsmasq.ips,
    dnsmasq_names = module.dnsmasq.names
  })
}
