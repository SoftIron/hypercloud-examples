resource "random_string" "security_group_suffix" {
  length = 4
  numeric = false
  special = false
}

resource "opennebula_security_group" "rke2_internal" {
  name        = "rke2-internal-insecure-${random_string.security_group_suffix.result}"
  description = "rke2 internal network security group"
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

resource "opennebula_security_group" "rke2_public" {
  name        = "rke2-public-facing-${random_string.security_group_suffix.result}"
  description = "rke2 public network security group"
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
