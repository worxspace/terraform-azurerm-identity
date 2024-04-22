data "azurerm_client_config" "current" {}

variable "location" {
  type        = string
  default     = "switzerlandnorth"
  description = "value for the location of the virtual machines"
}

variable "project-name" {
  type        = string
  description = "used as the main part of the name of the virtual machine"
}

variable "resource-prefixes" {
  type        = list(string)
  description = "these are prefixed to resource names and usually include the tenant short name and/or the environment name"

  default = []
}

variable "resource-suffixes" {
  type        = list(string)
  description = "these are appended to resource names and usually include the numbers when multiple resource with the same name exist"

  default = []
}

variable "address-space" {
  type        = list(string)
  description = "address space of the virtual network for this landing zone"
}

variable "firewall-ip" {
  type        = string
  default     = null
  description = "ip address of the firewall used for forward subnet traffic to the internet"
}

variable "domain-controller" {
  type = object({
    vm-size           = optional(string, "Standard_D2s_V2")
    high-availability = optional(bool, true)
    vtpm-enabled      = optional(bool, true)
  })
  default     = null
  description = "attributes for the domain controller virtual machines"
}

variable "adsync" {
  type = object({
    vm-size      = optional(string, "Standard_B2s")
    vtpm-enabled = optional(bool, true)
  })
  default     = null
  description = "attributes for the adsync virtual machine"
}

variable "vm_source_image_id" {
  type        = string
  default     = null
  description = "defines the custom gallery image to be used for deploying identity vms"
}
