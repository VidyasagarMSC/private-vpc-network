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

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "vpc_subnets" {
  type        = any
  description = "List of subnets"
}

##########################################################################
# Client to Site VPN
##########################################################################

variable "vpn_client_ip_pool" {
  type        = string
  default     = "192.168.0.0/16"
  description = "Prviate IP pool for the client to site VPN"
}

variable "vpn_client_dns_server_ips" {
  type        = list(string)
  default     = ["192.168.1.0", "192.168.1.1"]
  description = "optional client DNS server IPs from the client IP pool"
}

variable "vpn_client_idle_timeout" {
  type        = string
  default     = "2800"
  description = "client to site VPN connection timeout"
}

variable "vpn_port" {
  type        = number
  default     = 443
  description = "client to site VPN port"
}

variable "vpn_enable_split_tunneling" {
  type        = bool
  default     = false
  description = "If set to true, Split tunneling is enabled."
}

variable "vpn_protocol" {
  type        = string
  default     = "udp"
  description = "Choose between tcp and udp for the protocol."
}

variable "vpn_server_route_destinations" {
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.65.0/24"]
  description = "The VPN server route to the destination CIDR."
}

variable "vpn_server_route_action" {
  type        = string
  default     = "deliver"
  description = "The action for the VPN server route - deliver or translate."
}

variable "vpn_client_authentication_methods" {
  type = list(object({
    method        = string,
    client_ca_crn = optional(string),
  identity_provider = optional(string) }))
  description = "Authentication methods: certificate,username"
  default = [{
    method = "certificate"
    #client_ca_crn = "",
    #{
    #method            = "username",
    #identity_provider = "iam"
    }
  ]
}

variable "client_to_site_vpn_deliver_private_sg_rules" {
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
      "name" : "allow-inbound-deliver-to-bastion",
      "remote" : "10.10.0.0/17"
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-deliver-to-bastion",
      "remote" : "10.10.0.0/17"
    }
  ]

}

variable "client_to_site_vpn_sg_rules" {
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
      "name" : "allow-inbound-vpn",
      "remote" : "0.0.0.0/0",
      "udp" : {
        "port_max" : 443,
        "port_min" : 443
      }
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-vpn",
      "remote" : "0.0.0.0/0",
      "udp" : {
        "port_max" : 443,
        "port_min" : 443
      }
      }, {
      "direction" : "inbound",
      "name" : "allow-inbound-tcp",
      "remote" : "0.0.0.0/0",
      "tcp" : {
        "port_max" : 8080,
        "port_min" : 8080
      }
    },
    {
      "direction" : "outbound",
      "name" : "allow-outbound-tcp",
      "remote" : "0.0.0.0/0",
      "tcp" : {
        "port_max" : 8080,
        "port_min" : 8080
      }
    }
  ]
}

variable "secrets_manager_certificate_crn" {
  type        = string
  description = "Secrets manager certificate CRN"
}

variable "allow_port_9090" {
  type        = bool
  description = "Allow traffic on port 9090 for session recording web console"
  default     = false
}