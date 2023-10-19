terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "1.2.1"
    }
  }
}

provider "opennebula" {
  endpoint      = "https://hypercloud.softiron.com:2634/RPC2"
  flow_endpoint = "https://hypercloud.softiron.com:2475/RPC2"
  username      = var.one_username
  password      = var.one_password
}
