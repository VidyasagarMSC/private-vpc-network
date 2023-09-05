resource "ibm_is_vpn_server" "client_to_site" {
  certificate_crn = var.secrets_manager_certificate_crn
  dynamic "client_authentication" {
    for_each = var.vpn_client_authentication_methods
    content {
      method            = client_authentication.value["method"]
      client_ca_crn     = client_authentication.value["client_ca_crn"]
      identity_provider = client_authentication.value["identity_provider"]
    }
  }
  client_ip_pool         = var.vpn_client_ip_pool
  client_dns_server_ips  = var.vpn_client_dns_server_ips
  client_idle_timeout    = var.vpn_client_idle_timeout
  enable_split_tunneling = var.vpn_enable_split_tunneling
  name                   = "${var.prefix}-client-to-site-vpn"
  port                   = var.vpn_port
  protocol               = var.vpn_protocol
  subnets                = local.client_to_site_vpn_subnets
  security_groups        = [ibm_is_security_group.client_to_site_vpn_sg.id, ibm_is_security_group.client_to_site_vpn_deliver_sg.id]
  resource_group         = var.resource_group_id
}

resource "ibm_is_vpn_server_route" "client_to_site_vpn_route" {
  count       = 2
  vpn_server  = ibm_is_vpn_server.client_to_site.vpn_server
  destination = var.vpn_server_route_destinations[count.index]
  action      = var.vpn_server_route_action
  name        = "${var.prefix}-client-to-site-vpn-server-route-${count.index + 1}"
}

locals {
  client_to_site_vpn_subnets = [
    for subnet in var.vpc_subnets : subnet.id
    if can(regex("client-to-site", subnet.name))
  ]
}