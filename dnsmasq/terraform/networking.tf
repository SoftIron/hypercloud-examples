resource "random_string" "security_group_suffix" {
  length = 4
  numeric = false
  special = false
}

resource "opennebula_security_group" "dnsmasq_internal" {
  name        = "dnsmasq-internal-insecure-${random_string.security_group_suffix.result}"
  description = "dnsmasq internal network security group"
  group       = var.hypercloud_group

  rule {
    protocol  = "ALL"
    rule_type = "OUTBOUND"
  }

  rule {
    protocol  = "ICMP"
    rule_type = "INBOUND"
  }

  rule {
    protocol  = "TCP"
    rule_type = "INBOUND"
    range     = "22"
  }

  rule {
    protocol  = "UDP"
    rule_type = "INBOUND"
    range     = "53"
  }

}
