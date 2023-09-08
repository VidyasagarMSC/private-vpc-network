resource "ibm_resource_group" "group" {
  name = "${var.prefix}-rg"
}

module "bastion" {
  source = "./bastion"
  vpc_id = ibm_is_vpc.vpc.id
  subnets = ibm_is_subnet.subnets
  prefix = var.prefix
  resource_group_id = ibm_resource_group.group.id
  ibm_cloud_region = var.ibm_cloud_region
}

module "vpn" {
  source = "./vpn"
  vpc_id = ibm_is_vpc.vpc.id
  vpc_subnets = ibm_is_subnet.subnets
  prefix = var.prefix
  resource_group_id = ibm_resource_group.group.id
  ibm_cloud_region = var.ibm_cloud_region
  secrets_manager_certificate_crn = var.secrets_manager_certificate_crn
}