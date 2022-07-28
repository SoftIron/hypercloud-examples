output "ips" {
  description = "List of IP addresses created by this module"
  value       = opennebula_virtual_machine.instance.*.nic.0.computed_ip
}

output "names" {
  description = "List of host names created by this module"
  value       = opennebula_virtual_machine.instance.*.name
}
