variable "ibm_cloud_region" {
  type        = string
  description = "IBM Cloud region to provision the resources."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  default     = "ha-bastion"
  description = "The string that needs to be attached to every resource created"
}

variable "resource_group_id" {
  type        = string
  description = "The resource group where all the resources will be provisioned."
}

variable "vpc_id"{
  type        = string
  description = "VPC id"
}

variable "subnets" {
    type = any
    description = "List of subnets"
}

##################################################################################
# BASTION variables
##################################################################################

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
      "remote" : "10.10.128.0/24",
      "tcp" : {
        "port_max" : 22,
        "port_min" : 22
      }
    },
    {
      "direction" : "inbound",
      "name" : "allow-inbound-bastion-icmp",
      "remote" : "10.10.128.0/24",
      icmp : {
        type : 8
        code : null
      }
    },
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
      "direction" : "outbound",
      "name" : "allow-outbound-bastion",
      "remote" : "192.168.0.0/16"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-host",
      "remote" : "10.10.128.0/24"
    },
    
    {
      "direction" : "outbound",
      "name" : "allow-outbound-mirror",
      "remote" : "161.26.0.0/16"
    },
  ]
}