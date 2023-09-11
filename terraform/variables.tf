variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API key"
}

variable "ibm_cloud_region" {
  type        = string
  description = "IBM Cloud region to provision the resources."
  default     = "eu-de"
}

variable "prefix" {
  type        = string
  default     = "private-ha"
  description = "The string that needs to be attached to every resource created"
}
variable "vpc_name" {
  type        = string
  default     = "vpc"
  description = "The name of the customer edge vpc"
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
  default = "eu-de"
}

#################################################################################
# VSI specific variables
#################################################################################

variable "vsi_image" {
  type        = string
  default     = "ibm-redhat-8-6-minimal-amd64-4"
  description = "To see the available images run ibmcloud is images command"
}

variable "vsi_profile" {
  type        = string
  default     = "bx2-2x8"
  description = "To see the available images run ibmcloud is images command"
}

variable "vsi_private_sg_rules" {
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
      "name" : "allow-inbound-ssh",
      "remote" : "10.10.0.0/17",
      "tcp" : {
        "port_max" : 22,
        "port_min" : 22
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-icmp",
      "remote" : "10.10.0.0/17",
      icmp : {
        type : 8
        code : null
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-rhel-mirror",
      "remote" : "161.26.0.0/16"
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-vpe-to-vsi-rule",
      "remote" : "166.9.0.0/16"
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-lb-to-vsi-rule",
      "remote" : "10.10.128.0/24"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-ase",
      "remote" : "10.10.128.0/24"
    },

    {
      "direction" : "outbound",
      "name" : "allow-outbound-rhel-mirror",
      "remote" : "161.26.0.0/16"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-vsi-to-vpe-rule",
      "remote" : "166.9.0.0/16"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-rule",
      "remote" : "10.10.128.0/24"
    },
  ]
}


#################################################################################
# VPC Variables
#################################################################################

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
        "acl_name" : "vpc-bastion-subnet-acl",
        "cidr" : "10.10.0.0/24",
        "name" : "vpc-zone1-bastion-subnet",
        "public_gateway" : false
      },
      {
        "acl_name" : "vpc-client-to-site-vpn-acl",
        "cidr" : "10.10.1.0/24",
        "name" : "vpc-zone1-client-to-site-subnet",
        "public_gateway" : false
      }
    ],
    "zone-2" : [
      {
        "acl_name" : "vpc-client-to-site-vpn-acl",
        "cidr" : "10.10.64.0/24",
        "name" : "vpc-zone2-client-to-site-subnet",
        "public_gateway" : false
      },
      {
        "acl_name" : "vpc-bastion-subnet-acl",
        "cidr" : "10.10.65.0/24",
        "name" : "vpc-zone2-bastion-subnet",
        "public_gateway" : false
      }
    ],
    "zone-3" : [
      {
        "acl_name" : "vsi-acl",
        "cidr" : "10.10.128.0/24",
        "name" : "vpc-zone3-rhel-vsi-subnet",
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

###############################################################################
# Client certificates - Secrets Manager
##############################################################################

variable "secrets_manager_certificate_crn" {
  type        = string
  description = "The CRN of the secret created in secrets manager."
}

###############################################################################
# Session recording variables 
##############################################################################

variable "allow_port_9090" {
  type        = bool
  description = "Allow traffic on port 9090 for session recording web console"
  default     = false
}