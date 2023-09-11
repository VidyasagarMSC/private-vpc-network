resource "ibm_is_subnet" "subnets" {
  for_each        = local.subnet_objects
  vpc             = ibm_is_vpc.vpc.id
  name            = each.key
  zone            = each.value.zone_name
  resource_group  = ibm_resource_group.group.id
  ipv4_cidr_block = each.value.cidr
  network_acl     = each.value.acl_id
  routing_table   = ibm_is_vpc.vpc.default_routing_table
  depends_on = [
    ibm_is_vpc_address_prefix.address
  ]
}

locals {
  # Convert subnets into a single list
  subnet_list = flatten([
    # For each key in the object create an array
    for zone in keys(var.vpc_subnets) :
    # Each item in the list contains information about a single subnet
    [
      for value in var.vpc_subnets[zone] :
      {
        name           = value.name                                                # Subnet shortname
        prefix_name    = "${var.prefix}-${value.name}"                             # Creates a name of the prefix and subnet name
        zone           = index(keys(var.vpc_subnets), zone) + 1                    # Zone 1, 2, or 3
        zone_name      = "${var.region}-${index(keys(var.vpc_subnets), zone) + 1}" # Contains ibmcloud_region and zone
        cidr           = value.cidr                                                # CIDR Block
        count          = index(var.vpc_subnets[zone], value) + 1                   # Count of the subnet within the zone
        public_gateway = value.public_gateway                                      # Public Gateway ID
        acl_id         = can(regex("bastion", value.name)) ? ibm_is_network_acl.bastion_subnet_acl.id : (can(regex("client-to-site", value.name)) ? ibm_is_network_acl.edge_vpc_client_to_site_vpn_acl.id : ibm_is_network_acl.vpc_rhel_vsi_subnet_acl.id)
      }
    ]
  ])

  # Create an object from the array for human readable reference
  subnet_objects = {
    for subnet in local.subnet_list :
    "${var.prefix}-${subnet.name}" => subnet
  }
}
