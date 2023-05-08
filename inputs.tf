data "azurerm_client_config" "current" {}

variable "tenant-name" {
  type = string
}

variable "tenant-short-name" {
  type = string
}

variable "location" {
  type    = string
  default = "switzerlandnorth"
}

variable "hub-vnet" {
  type = object({
    name                = string
    resource-group-name = string
    id                  = string
  })
}

variable "address-space" {
  type = list(string)
}

variable "firewall-ip" {
  type = string
}

variable "domain-controller" {
  type = object({
    vm-size           = optional(string, "Standard_D2s_V2")
    high-availability = optional(bool, true)
  })
  default = null
}

variable "adsync" {
  type = object({
    vm-size = optional(string, "Standard_B2s")
  })
  default = null
}
