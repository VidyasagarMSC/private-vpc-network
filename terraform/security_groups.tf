locals {

  security_group_rule_bastion_object = {
    for rule in var.bastion_sg_rules :
    rule.name => rule
  }

}


resource "ibm_is_security_group" "bastion_sg" {
  name           = "${var.prefix}-edge-bastion-sg"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = var.resource_group_id
}

resource "ibm_is_security_group_rule" "bastion_sg_rules" {
  for_each  = local.security_group_rule_bastion_object
  group     = ibm_is_security_group.bastion_sg.id
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