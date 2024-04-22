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

  providers = {
    azurerm.mi = azurerm.mi
  }

  project-name       = var.project-name
  resource-prefixes  = var.resource-prefixes
  resource-suffixes  = var.resource-suffixes
  location           = var.location
  vnet-address-space = var.address-space
  firewall-ip        = var.firewall-ip
  subnets = [
    {
      name          = "identity"
      address-space = var.address-space[0]
    }
  ]
}

resource "azurerm_virtual_network_dns_servers" "identity-dns" {
  virtual_network_id = module.landingzone.vnet-id
  dns_servers        = var.vm_source_image_id == null ? module.adds-vm-marketplace[*].ip-address : module.adds-vm-gallery[*].ip-address
}
