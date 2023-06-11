resource "ibm_is_subnet" "subnets" {
  for_each        = local.subnet_object
  vpc             = ibm_is_vpc.vpc.id
  name            = each.key
  zone            = each.value.zone_name
  resource_group  = var.resource_group_id
  ipv4_cidr_block = each.value.cidr
  network_acl     = each.value.acl_id
  routing_table   = ibm_is_vpc.vpc.default_routing_table
  depends_on = [
    ibm_is_vpc_address_prefix.address
  ]
}

resource "ibm_is_network_acl" "edge_vpc_bastion_subnet_acl" {
  vpc            = ibm_is_vpc.vpc.id
  name           = "${var.prefix}-customer-edge-vpc-bastion-subnet-acl"
  resource_group = var.resource_group_id
  rules {
    name        = "inbound-vpn-to-bastion"
    action      = "allow"
    source      = "192.168.0.0/16"
    destination = "10.10.0.0/17"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-bastion-to-vpn"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "192.168.0.0/16"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-vsi-to-mirror"
    action      = "allow"
    source      = "161.26.0.0/16"
    destination = "10.10.0.0/17"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-ase-to-vpn"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "10.30.0.0/17"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-vpn-to-management"
    action      = "allow"
    source      = "10.20.0.0/24"
    destination = "10.10.0.0/17"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-management-to-edge"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "10.20.0.0/24"
    direction   = "outbound"
  }
  rules {
    name        = "outbound-vsi-to-mirror"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "161.26.0.0/16"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-deny-bastion-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-deny-bastion-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
  }
}

resource "ibm_is_network_acl" "edge_vpc_client_to_site_vpn_acl" {
  vpc            = ibm_is_vpc.vpc.id
  name           = "${var.prefix}-customer-edge-vpc-client-to-site-vpn-acl"
  resource_group = var.resource_group_id
  rules {
    name        = "inbound-client-to-site-az1"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "10.10.1.0/24"
    direction   = "inbound"
    udp {
      port_max = 443
      port_min = 443
    }
  }
  rules {
    name        = "inbound-client-to-site-az2"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "10.10.64.0/24"
    direction   = "inbound"
    udp {
      port_max = 443
      port_min = 443
    }
  }
  rules {
    name        = "inbound-bastion-to-vpn"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "192.168.0.0/16"
    direction   = "inbound"
  }
  rules {
    name        = "inbound-bastion-to-ase-vsi"
    action      = "allow"
    source      = "10.30.0.0/17"
    destination = "10.10.0.0/17"
    direction   = "inbound"
  }
  rules {
    name        = "inbound-deny-vpn-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-client-to-site-az1"
    action      = "allow"
    source      = "10.10.1.0/24"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    udp {
      source_port_max = 443
      source_port_min = 443
    }
  }
  rules {
    name        = "outbound-client-to-site-az2"
    action      = "allow"
    source      = "10.10.64.0/24"
    destination = "0.0.0.0/0"
    direction   = "outbound"
    udp {
      source_port_max = 443
      source_port_min = 443
    }
  }
  rules {
    name        = "outbound-vpn-to-bastion"
    action      = "allow"
    source      = "192.168.0.0/16"
    destination = "10.10.0.0/17"
    direction   = "outbound"
  }
  rules {
    name        = "outbound-bastion-to-ase-vsi"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "10.30.0.0/17"
    direction   = "outbound"
  }
  rules {
    name        = "outbound-deny-vpn-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
  }

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
        acl_id         = can(regex("bastion", value.name)) ? ibm_is_network_acl.edge_vpc_bastion_subnet_acl.id : (can(regex("client-to-site", value.name)) ? ibm_is_network_acl.edge_vpc_client_to_site_vpn_acl.id : ibm_is_vpc.vpc.default_network_acl)
      }
    ]
  ])

  # Create an object from the array for human readable reference
  subnet_object = {
    for subnet in local.subnet_list :
    "${var.prefix}-${subnet.name}" => subnet
  }
}
