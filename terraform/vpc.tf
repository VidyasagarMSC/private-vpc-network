resource "ibm_is_vpc" "vpc" {
  name                        = "${var.prefix}-${var.vpc_name}"
  resource_group              = var.resource_group_id
  default_network_acl_name    = "${var.prefix}-customer-edge-vpc-${var.default_network_acl_name}"
  default_security_group_name = "${var.prefix}-customer-edge-vpc-sg"
  default_routing_table_name  = "${var.prefix}-customer-edge-vpc-routing-table"
  address_prefix_management   = "manual"
  tags                        = ["vpc:customer-edge"]
}

resource "ibm_is_vpc_address_prefix" "address" {
  for_each = local.address_prefix_object
  name     = each.key
  zone     = each.value.zone
  vpc      = ibm_is_vpc.vpc.id
  cidr     = each.value.cidr
}

/*resource "ibm_is_vpc_routing_table" "routing_table" {
  vpc                           = ibm_is_vpc.vpc.id
  name                          = "${var.prefix}-customer-edge-vpc-routing-table"
  route_direct_link_ingress     = false
  route_transit_gateway_ingress = false
  route_vpc_zone_ingress        = false
}*/

module "client_to_site_vpn" {
  source                 = "../../vpn/client-to-site-vpn"
  prefix                 = var.prefix
  resource_group_id      = var.resource_group_id
  vpc_id                 = ibm_is_vpc.vpc.id
  subnets                = ibm_is_subnet.subnets
  enable_split_tunneling = true
}

locals {
  address_prefix_list = flatten([
    for zone in keys(var.address_prefixes) :
    [
      for address in(var.address_prefixes != null ? lookup(var.address_prefixes, zone, null) == null ? [] : var.address_prefixes[zone] : []) :
      {
        name = "${var.prefix}-${zone}-${index(var.address_prefixes[zone], address) + 1}"
        cidr = address
        zone = "${var.region}-${index(keys(var.address_prefixes), zone) + 1}"
      }
    ]
  ])

  address_prefix_object = {
    for address_prefix in local.address_prefix_list :
    "${address_prefix.name}-address-prefix" => address_prefix
  }

}
