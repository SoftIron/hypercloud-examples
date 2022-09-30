terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
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

  hard_shutdown = true

  context = {
    SSH_PUBLIC_KEY = var.ssh_key
    NETWORK      = "YES"
    SET_HOSTNAME = "$NAME"
    TOKEN        = "YES"
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = var.image_id
    size     = 20000
    target   = "vda"
  }

  on_disk_change = "RECREATE"

  graphics {
    type   = "VNC"
    listen = "0.0.0.0"
  }

  nic {
    network_id      = var.network_id
    security_groups = var.security_groups
    ip              = var.ip
  }

  dynamic "nic"{
    for_each = var.second_nic == true ? [{net_id=var.second_nic_net, net_sgs=var.second_nic_sgs}] : []
    content {
      network_id    = nic.value["net_id"]
      security_groups = nic.value["net_sgs"]
    }
  }
}
