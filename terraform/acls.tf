resource "ibm_is_network_acl" "bastion_subnet_acl" {
  vpc            = ibm_is_vpc.vpc.id
  name           = "${var.prefix}-edge-vpc-bastion-subnet-acl"
  resource_group = ibm_resource_group.group.id
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
    name        = "inbound-vsi-to-bastion"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "10.10.0.0/17"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-vsi-to-bastion"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "10.10.128.0/24"
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
  name           = "${var.prefix}-edge-vpc-client-to-site-vpn-acl"
  resource_group = ibm_resource_group.group.id
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
    name        = "inbound-bastion-to-vsi"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "10.10.0.0/17"
    direction   = "inbound"
  }
  rules {
    name        = "inbound-vpn-vsi-9090-rule"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    tcp {
      port_max = 9090
      port_min = 9090
    }
    direction = "inbound"
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
    name        = "outbound-bastion-to-vsi"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "10.10.128.0/24"
    direction   = "outbound"
  }
  rules {
    name        = "outbound-vpn-vsi-9090-rule"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    tcp {
      port_max = 9090
      port_min = 9090
    }
    direction = "outbound"
  }
  rules {
    name        = "outbound-deny-vpn-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
  }

}

resource "ibm_is_network_acl" "vpc_rhel_vsi_subnet_acl" {
  vpc            = ibm_is_vpc.vpc.id
  name           = "${var.prefix}-vpc-vsi-subnet-acl"
  resource_group = ibm_resource_group.group.id
  rules {
    name        = "inbound-vpn-to-bastion"
    action      = "allow"
    source      = "10.10.0.0/17"
    destination = "10.10.128.0/24"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-bastion-to-vpn"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "10.10.0.0/17"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-rhel-mirror-to-subnet"
    action      = "allow"
    source      = "161.26.0.0/16"
    destination = "10.10.128.0/24"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-subnet-to-rhel-mirror"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "161.26.0.0/16"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-vpe-rule"
    action      = "allow"
    source      = "166.9.0.0/16"
    destination = "10.10.128.0/24"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-vpe-rule"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "166.9.0.0/16"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-cidr-rule"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "10.10.128.0/24"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-cidr-rule"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "10.10.128.0/24"
    direction   = "outbound"
  }
  rules {
    name        = "inbound-vpn-cidr-9090-rule"
    action      = "allow"
    source      = "192.168.0.0/24"
    destination = "10.10.128.0/24"
    tcp {
      port_max = 9090
      port_min = 9090
    }
    direction = "inbound"
  }
  rules {
    name        = "outbound-vpn-cidr-9090-rule"
    action      = "allow"
    source      = "10.10.128.0/24"
    destination = "192.168.0.0/24"
    tcp {
      port_max = 9090
      port_min = 9090
    }
    direction = "outbound"
  }
  rules {
    name        = "inbound-deny-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
  }
  rules {
    name        = "outbound-deny-all"
    action      = "deny"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
  }
}
