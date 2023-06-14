/**
 * # tfm-azure-identity
 *
 * Creates ADDS landing zone in azure in a standardised way using the latest recommendations.
 *
 * We use azurecaf_name to generate a unique name for the user assigned identity.
 * so make sure to provide the project-name, prefixes, suffixes as necessary
 */

module "landingzone" {
  source  = "app.terraform.io/worxspace/landingzone/azurerm"
  version = "~>0.0.6"

  project-name       = var.project-name
  resource-prefixes  = var.resource-prefixes
  resource-suffixes  = var.resource-suffixes
  location           = var.location
  vnet-address-space = var.address-space
  firewall-ip        = var.firewall-ip
}

module "identity-subnet" {
  source  = "app.terraform.io/worxspace/subnet/azurerm"
  version = "~>0.0.5"

  project-name        = "identity"
  resource-prefixes   = var.resource-prefixes
  resource-suffixes   = var.resource-suffixes
  resource-group-name = module.landingzone.vnet-resource-group-name
  location            = var.location
  vnet-name           = module.landingzone.vnet-name
  address-prefix      = var.address-space[0]
  firewall-ip         = var.firewall-ip
}

resource "azurerm_virtual_network_dns_servers" "identity-dns" {
  virtual_network_id = module.landingzone.vnet-id
  dns_servers        = module.adds-vm[*].ip-address
}
