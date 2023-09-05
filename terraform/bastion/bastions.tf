data "ibm_is_image" "bastion_rhel" {
  name = var.vsi_bastion_image
}

data "ibm_is_ssh_key" "bastion" {
  name = "vidya-ssh"
}

resource "ibm_is_subnet_reserved_ip" "bastion" {
  count   = 2
  subnet  = local.bastion_subnet[count.index].id
  name    = "${var.prefix}-bastion-reserved-ip"
  address = replace(local.bastion_subnet[count.index].ipv4_cidr_block, "0/24", "13")
}

resource "ibm_is_instance" "bastion" {
  count          = 2
  name           = "${var.prefix}-bastion-${local.bastion_subnet[count.index].zone}-vsi"
  image          = data.ibm_is_image.bastion_rhel.id
  profile        = var.vsi_bastion_profile
  resource_group = var.resource_group_id

  primary_network_interface {
    name            = "eth0"
    subnet          = local.bastion_subnet[count.index].id
    security_groups = [ibm_is_security_group.bastion_sg.id]
    primary_ip {
      reserved_ip = ibm_is_subnet_reserved_ip.bastion[count.index].reserved_ip
    }
  }

  vpc  = var.vpc_id
  zone = local.bastion_subnet[count.index].zone
  keys = [data.ibm_is_ssh_key.bastion.id]
}

locals {
  bastion_subnet = [
    for subnet in var.vpc_subnets : subnet
    if can(regex("bastion", subnet.name))
  ]
}
