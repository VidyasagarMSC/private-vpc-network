locals {
  security_group_rule_private_vsi_object = {
    for rule in var.vsi_private_sg_rules :
    rule.name => rule
  }

}

resource "ibm_is_security_group" "vsi_sg" {
  name           = "${var.prefix}-vsi-sg"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = ibm_resource_group.group.id
}

resource "ibm_is_security_group_rule" "vsi_sg_rules" {
  for_each  = local.security_group_rule_private_vsi_object
  group     = ibm_is_security_group.vsi_sg.id
  direction = each.value.direction
  remote    = each.value.remote

  dynamic "tcp" {
    for_each = each.value.tcp == null ? [] : [each.value]
    content {
      port_min = each.value.tcp.port_min
      port_max = each.value.tcp.port_max
    }
  }

  dynamic "udp" {
    for_each = each.value.udp == null ? [] : [each.value]
    content {
      port_min = each.value.udp.port_min
      port_max = each.value.udp.port_max
    }
  }

  dynamic "icmp" {
    for_each = each.value.icmp == null ? [] : [each.value]
    content {
      type = each.value.icmp.type
      code = each.value.icmp.code
    }
  }
}

###########################################################################
# Security group rules to allow inbound and outbound traffic on port 9090
# for session recording web console
###########################################################################
resource "ibm_is_security_group_rule" "allow_9090_inbound" {
  count     = var.allow_port_9090 ? 1 : 0
  group     = ibm_is_security_group.vsi_sg.id
  direction = "inbound"
  remote    = "0.0.0.0"
  tcp {
    port_min = 9090
    port_max = 9090
  }
}

resource "ibm_is_security_group_rule" "allow_9090_outbound" {
  count     = var.allow_port_9090 ? 1 : 0
  group     = ibm_is_security_group.vsi_sg.id
  direction = "outbound"
  remote    = "0.0.0.0"
  tcp {
    port_min = 9090
    port_max = 9090
  }
}