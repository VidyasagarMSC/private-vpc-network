## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.49.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.56.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./bastion | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [ibm_is_instance.rhel_vsi](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance) | resource |
| [ibm_is_network_acl.bastion_subnet_acl](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_network_acl) | resource |
| [ibm_is_network_acl.edge_vpc_client_to_site_vpn_acl](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_network_acl) | resource |
| [ibm_is_network_acl.vpc_rhel_vsi_subnet_acl](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_network_acl) | resource |
| [ibm_is_security_group.vsi_sg](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group) | resource |
| [ibm_is_security_group_rule.vsi_sg_rules](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_subnet.subnets](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet) | resource |
| [ibm_is_subnet_reserved_ip.rhel_vsi_ip](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet_reserved_ip) | resource |
| [ibm_is_vpc.vpc](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_vpc) | resource |
| [ibm_is_vpc_address_prefix.address](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_vpc_address_prefix) | resource |
| [ibm_resource_group.group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_group) | resource |
| [ibm_is_image.rhel](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/is_image) | data source |
| [ibm_is_ssh_key.rhel_ssh](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/is_ssh_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | n/a | <pre>object({<br>    zone-1 = optional(list(string))<br>    zone-2 = optional(list(string))<br>    zone-3 = optional(list(string))<br>  })</pre> | <pre>{<br>  "zone-1": [<br>    "10.10.0.0/18"<br>  ],<br>  "zone-2": [<br>    "10.10.64.0/18"<br>  ],<br>  "zone-3": [<br>    "10.10.128.0/18"<br>  ]<br>}</pre> | no |
| <a name="input_default_network_acl_name"></a> [default\_network\_acl\_name](#input\_default\_network\_acl\_name) | n/a | `string` | `"default-acl"` | no |
| <a name="input_go_private"></a> [go\_private](#input\_go\_private) | Set this to TRUE if you plan to use client to site VPN and go private | `bool` | `false` | no |
| <a name="input_ibm_cloud_region"></a> [ibm\_cloud\_region](#input\_ibm\_cloud\_region) | IBM Cloud region to provision the resources. | `string` | `"eu-de"` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | IBM Cloud API key | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The string that needs to be attached to every resource created | `string` | `"private-ha"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"eu-de"` | no |
| <a name="input_secrets_manager_certificate_crn"></a> [secrets\_manager\_certificate\_crn](#input\_secrets\_manager\_certificate\_crn) | The CRN of the secret created in secrets manager. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the customer edge vpc | `string` | `"vpc"` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | Subnets in the customer edge VPC | <pre>object({<br>    zone-1 = list(object({<br>      name           = string<br>      cidr           = string<br>      public_gateway = optional(bool)<br>      acl_name       = string<br>    }))<br>    zone-2 = list(object({<br>      name           = string<br>      cidr           = string<br>      public_gateway = optional(bool)<br>      acl_name       = string<br>    }))<br>    zone-3 = list(object({<br>      name           = string<br>      cidr           = string<br>      public_gateway = optional(bool)<br>      acl_name       = string<br>    }))<br>  })</pre> | <pre>{<br>  "zone-1": [<br>    {<br>      "acl_name": "vpc-bastion-subnet-acl",<br>      "cidr": "10.10.0.0/24",<br>      "name": "vpc-zone1-bastion-subnet",<br>      "public_gateway": false<br>    },<br>    {<br>      "acl_name": "vpc-client-to-site-vpn-acl",<br>      "cidr": "10.10.1.0/24",<br>      "name": "vpc-zone1-client-to-site-subnet",<br>      "public_gateway": false<br>    }<br>  ],<br>  "zone-2": [<br>    {<br>      "acl_name": "vpc-client-to-site-vpn-acl",<br>      "cidr": "10.10.64.0/24",<br>      "name": "vpc-zone2-client-to-site-subnet",<br>      "public_gateway": false<br>    },<br>    {<br>      "acl_name": "vpc-bastion-subnet-acl",<br>      "cidr": "10.10.65.0/24",<br>      "name": "vpc-zone2-bastion-subnet",<br>      "public_gateway": false<br>    }<br>  ],<br>  "zone-3": [<br>    {<br>      "acl_name": "vsi-acl",<br>      "cidr": "10.10.128.0/24",<br>      "name": "vpc-zone3-rhel-vsi-subnet",<br>      "public_gateway": false<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_vsi_image"></a> [vsi\_image](#input\_vsi\_image) | To see the available images run ibmcloud is images command | `string` | `"ibm-redhat-8-6-minimal-amd64-4"` | no |
| <a name="input_vsi_private_sg_rules"></a> [vsi\_private\_sg\_rules](#input\_vsi\_private\_sg\_rules) | n/a | <pre>list(<br>    object({<br>      name      = string<br>      direction = string<br>      remote    = string<br>      tcp = optional(<br>        object({<br>          port_max = optional(number)<br>          port_min = optional(number)<br>        })<br>      )<br>      udp = optional(<br>        object({<br>          port_max = optional(number)<br>          port_min = optional(number)<br>        })<br>      )<br>      icmp = optional(<br>        object({<br>          type = optional(number)<br>          code = optional(number)<br>        })<br>      )<br>    })<br>  )</pre> | <pre>[<br>  {<br>    "direction": "inbound",<br>    "name": "allow-inbound-ssh",<br>    "remote": "10.10.0.0/17",<br>    "tcp": {<br>      "port_max": 22,<br>      "port_min": 22<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "icmp": {<br>      "code": null,<br>      "type": 8<br>    },<br>    "name": "allow-inbound-icmp",<br>    "remote": "10.10.0.0/17"<br>  },<br>  {<br>    "direction": "inbound",<br>    "name": "allow-inbound-rhel-mirror",<br>    "remote": "161.26.0.0/16"<br>  },<br>  {<br>    "direction": "inbound",<br>    "name": "allow-inbound-vpe-to-vsi-rule",<br>    "remote": "166.9.0.0/16"<br>  },<br>  {<br>    "direction": "inbound",<br>    "name": "allow-inbound-lb-to-vsi-rule",<br>    "remote": "10.10.128.0/24"<br>  },<br>  {<br>    "direction": "outbound",<br>    "name": "allow-outbound-ase",<br>    "remote": "10.10.128.0/24"<br>  },<br>  {<br>    "direction": "outbound",<br>    "name": "allow-outbound-rhel-mirror",<br>    "remote": "161.26.0.0/16"<br>  },<br>  {<br>    "direction": "outbound",<br>    "name": "allow-outbound-vsi-to-vpe-rule",<br>    "remote": "166.9.0.0/16"<br>  },<br>  {<br>    "direction": "outbound",<br>    "name": "allow-outbound-management-to-workload-rule",<br>    "remote": "10.10.128.0/24"<br>  }<br>]</pre> | no |
| <a name="input_vsi_profile"></a> [vsi\_profile](#input\_vsi\_profile) | To see the available images run ibmcloud is images command | `string` | `"bx2-2x8"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_subnets"></a> [bastion\_subnets](#output\_bastion\_subnets) | n/a |
