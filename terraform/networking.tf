resource "opennebula_security_group" "k3s_internal" {
  name        = "k3s-internal-insecure"
  description = "k3s internal network security group"
  group       = var.hypercloud_group

  rule {
    protocol  = "ALL"
    rule_type = "OUTBOUND"
  }

  rule {
    protocol  = "ALL"
    rule_type = "INBOUND"
  }
}

resource "opennebula_security_group" "k3s_public" {
  name        = "k3s-public-facing"
  description = "k3s public network security group"
  group       = var.hypercloud_group

  rule {
    protocol  = "ALL"
    rule_type = "OUTBOUND"
  }

  rule {
    protocol  = "TCP"
    rule_type = "INBOUND"
    range     = "80,443"
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
}
