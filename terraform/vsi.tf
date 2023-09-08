data "ibm_is_image" "rhel" {
  name = var.vsi_image
}

data "ibm_is_ssh_key" "rhel_ssh" {
  name = "vidya-ssh"
}

resource "ibm_is_subnet_reserved_ip" "rhel_vsi_ip" {
  count   = length(local.vsi_subnet)
  subnet  = local.vsi_subnet[count.index].id
  name    = "${var.prefix}-vsi-reserved-ip"
  address = replace(local.vsi_subnet[count.index].ipv4_cidr_block, "0/24", "13")
}

resource "ibm_is_instance" "rhel_vsi" {
  count          = length(local.vsi_subnet)
  name           = "${var.prefix}-rhel-${local.vsi_subnet[count.index].zone}-vsi"
  image          = data.ibm_is_image.rhel.id
  profile        = var.vsi_profile
  resource_group = ibm_resource_group.group.id

  primary_network_interface {
    name            = "eth0"
    subnet          = local.vsi_subnet[count.index].id
    security_groups = [ibm_is_security_group.vsi_sg.id]
    primary_ip {
      reserved_ip = ibm_is_subnet_reserved_ip.rhel_vsi_ip[count.index].reserved_ip
    }
  }

  vpc  = ibm_is_vpc.vpc.id
  zone = local.vsi_subnet[count.index].zone
  keys = [data.ibm_is_ssh_key.rhel_ssh.id]
}


locals {
  vsi_subnet = [
    for subnet in ibm_is_subnet.subnets : subnet
    if can(regex("vsi", subnet.name))
  ]
}