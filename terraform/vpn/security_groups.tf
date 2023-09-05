locals {

  security_group_rule_deliver_private_vpn_object = {
    for rule in var.client_to_site_vpn_deliver_private_sg_rules :
    rule.name => rule
  }

  security_group_rule_vpn_object = {
    for rule in var.client_to_site_vpn_sg_rules :
    rule.name => rule
  }

}

resource "ibm_is_security_group" "client_to_site_vpn_deliver_sg" {
  name           = "${var.prefix}-client-to-site-vpn-deliver-sg"
  vpc            = var.vpc_id
  resource_group = var.resource_group_id
}


resource "ibm_is_security_group_rule" "client_to_site_vpn_deliver_rules" {
  for_each  = local.security_group_rule_deliver_private_vpn_object
  group     = ibm_is_security_group.client_to_site_vpn_deliver_sg.id
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

resource "ibm_is_security_group" "client_to_site_vpn_sg" {
  name           = "${var.prefix}-client-to-site-vpn-sg"
  vpc            = var.vpc_id
  resource_group = var.resource_group_id
}

resource "ibm_is_security_group_rule" "client_to_site_vpn_rules" {
  for_each  = local.security_group_rule_vpn_object
  group     = ibm_is_security_group.client_to_site_vpn_sg.id
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