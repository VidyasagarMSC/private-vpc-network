variable "prefix" {
  type        = string
  default     = "ha-bastion"
  description = "The string that needs to be attached to every resource created"
}
variable "vpc_name" {
  type        = string
  default     = "edge-vpc"
  description = "The name of the customer edge vpc"
}

variable "resource_group_id" {
  type        = string
  description = "The resource group where all the resources will be provisioned."
}

variable "address_prefixes" {
  type = object({
    zone-1 = optional(list(string))
    zone-2 = optional(list(string))
    zone-3 = optional(list(string))
  })
  default = {
    zone-1 = ["10.10.0.0/18"]
    zone-2 = ["10.10.64.0/18"]
    zone-3 = ["10.10.128.0/18"]
  }

}

variable "region" {
  type    = string
  default = "us-south"
}

variable "vsi_bastion_image" {
  type        = string
  default     = "ibm-redhat-8-6-minimal-amd64-4"
  description = "To see the available images run ibmcloud is images command"
}

variable "vsi_bastion_profile" {
  type        = string
  default     = "bx2-2x8"
  description = "To see the available images run ibmcloud is images command"
}

variable "vpc_subnets" {
  description = "Subnets in the customer edge VPC"
  type = object({
    zone-1 = list(object({
      name           = string
      cidr           = string
      public_gateway = optional(bool)
      acl_name       = string
    }))
    zone-2 = list(object({
      name           = string
      cidr           = string
      public_gateway = optional(bool)
      acl_name       = string
    }))
    zone-3 = list(object({
      name           = string
      cidr           = string
      public_gateway = optional(bool)
      acl_name       = string
    }))
  })

  default = {
    "zone-1" : [
      {
        "acl_name" : "edge-vpc-bastion-subnet-acl",
        "cidr" : "10.10.0.0/24",
        "name" : "edge-vpc-zone1-bastion-subnet",
        "public_gateway" : false
      },
      {
        "acl_name" : "edge-vpc-client-to-site-vpn-acl",
        "cidr" : "10.10.1.0/24",
        "name" : "edge-vpc-zone1-client-to-site-subnet",
        "public_gateway" : false
      }
    ],
    "zone-2" : [
      {
        "acl_name" : "edge-vpc-client-to-site-vpn-acl",
        "cidr" : "10.10.64.0/24",
        "name" : "edge-vpc-zone2-client-to-site-subnet",
        "public_gateway" : false
      },
      {
        "acl_name" : "edge-vpc-bastion-subnet-acl",
        "cidr" : "10.10.65.0/24",
        "name" : "edge-vpc-zone2-bastion-subnet",
        "public_gateway" : false
      }
    ],
    "zone-3" : [
      {
        "acl_name" : "edge-default-acl",
        "cidr" : "10.10.128.0/24",
        "name" : "edge-vpc-zone3-site-to-site-subnet",
        "public_gateway" : false
      }
    ]
  }
}

variable "default_network_acl_name" {
  type    = string
  default = "default-acl"
}
// TODO: tags, Access tags, NO DEFAULTS


variable "bastion_sg_rules" {
  type = list(
    object({
      name      = string
      direction = string
      remote    = string
      tcp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      udp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      icmp = optional(
        object({
          type = optional(number)
          code = optional(number)
        })
      )
    })
  )

  default = [
    {
      "direction" : "inbound",
      "name" : "allow-inbound-bastion",
      "remote" : "192.168.0.0/16"
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-from-mirror",
      "remote" : "161.26.0.0/16"
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-bastion-ssh",
      "remote" : "10.30.0.0/17",
      "tcp" : {
        "port_max" : 22,
        "port_min" : 22
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-bastion-icmp",
      "remote" : "10.30.0.0/17",
      icmp : {
        type : 8
        code : null
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-bastion-management-ssh",
      "remote" : "10.20.0.0/24",
      "tcp" : {
        "port_max" : 22,
        "port_min" : 22
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-bastion-management-icmp",
      "remote" : "10.20.0.0/24",
      icmp : {
        type : 8
        code : null
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-ase-ssh",
      "remote" : "10.10.0.0/17",
      "tcp" : {
        "port_max" : 22,
        "port_min" : 22
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-ase-icmp",
      "remote" : "10.10.0.0/17",
      icmp : {
        type : 8
        code : null
      }
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-bastion",
      "remote" : "192.168.0.0/16"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-ase-host",
      "remote" : "10.30.0.0/17"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-management-host",
      "remote" : "10.20.0.0/24"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-mirror",
      "remote" : "161.26.0.0/16"
    },
  ]
}
