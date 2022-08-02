terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "0.5.1"
    }
  }
}

data "opennebula_group" "group" {
  name = var.group_name
}


resource "opennebula_virtual_machine" "instance" {
  count       = var.num
  name        = "${var.name}-${count.index + 1}"
  cpu         = var.cpus
  vcpu        = var.vcpus
  memory      = var.memory
  group       = data.opennebula_group.group.name
  permissions = "660"

  context = {
    SSH_PUBLIC_KEY = join("\n", var.ssh_key)
    NETWORK      = "YES"
    HOSTNAME     = "$NAME"
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = var.image_id
    size     = 10000
    target   = "vda"
  }

  on_disk_change = "RECREATE"

  sched_requirements = "FREE_CPU > 60"

  nic {
    network_id      = var.network_id
    security_groups = var.security_groups
  }

}
