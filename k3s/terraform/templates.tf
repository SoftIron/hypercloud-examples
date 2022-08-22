resource "local_file" "inventory" {
  filename = "${path.root}/../ansible/inventory/hosts"
  content = templatefile("${path.root}/templates/inventory.tpl", {
    server_ips = module.servers.ips,
    server_names = module.servers.names
    agent_ips = module.agents.ips,
    agent_names = module.agents.names,
    lb_ips = module.loadbalancers.ips,
    lb_names = module.loadbalancers.names
  })
}
