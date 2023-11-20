resource "azurecaf_name" "adsync-resource-group-name" {
  count = var.adsync == null ? 0 : 1

  resource_type = "azurerm_resource_group"
  name          = "${var.project-name}-adsync"
  prefixes      = var.resource-prefixes
  suffixes      = concat(var.resource-suffixes, ["001"])
}

resource "azurerm_resource_group" "adsync-resource-group" {
  count = var.adsync == null ? 0 : 1

  name     = azurecaf_name.adsync-resource-group-name[0].result
  location = var.location
}

resource "azurecaf_name" "vm-ade-key-adsync" {
  count = var.adsync == null ? 0 : 1

  resource_type = "azurerm_key_vault_key"
  name          = "${var.project-name}-adsync"
  prefixes      = var.resource-prefixes
  suffixes      = concat(["vm-${format("%03d", count.index)}"], var.resource-suffixes)
}

resource "azurerm_key_vault_key" "vm-ade-key-adsync" {
  count = var.adsync == null ? 0 : 1

  name         = azurecaf_name.vm-ade-key-adsync[count.index].result
  key_vault_id = azurerm_key_vault.identity-key-vault.id
  key_type     = "RSA"
  key_size     = 3072

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_role_assignment.identity-key-vault-current-officer
  ]
}

module "adsync-vm-marketplace" {
  count = var.adsync != null && var.vm_source_image_id == null ? 1 : 0

  source  = "app.terraform.io/worxspace/vm-windows/azurerm"
  version = "~>0.1.0"

  resource-group-name = azurerm_resource_group.adsync-resource-group[0].name
  location            = var.location
  project-name        = "adsync"
  resource-prefixes   = var.resource-prefixes
  resource-suffixes   = ["001"]
  subnet-id           = module.identity-subnet.subnet-id
  ip-address          = cidrhost(module.identity-subnet.address-prefixes[0], (count.index + 7)) # Note: the first 3 IPs are reserved by Azure. So starting at 4.

  vm-size                       = var.adsync.vm-size
  support-hvic                  = var.adsync.vtpm-enabled
  update-management-integration = false
  enable-azuread-login          = false

  disk-encryption = {
    key-vault-url            = azurerm_key_vault.identity-key-vault.vault_uri
    key-vault-encryption-url = azurerm_key_vault_key.vm-ade-key-adsync[count.index].id
    key-vault-resource-id    = azurerm_key_vault.identity-key-vault.id
  }
}

module "adsync-vm-gallery" {
  count = var.adsync != null && var.vm_source_image_id != null ? 1 : 0

  source  = "app.terraform.io/worxspace/vm-windows/azurerm"
  version = "~>0.1.0"

  resource-group-name = azurerm_resource_group.adsync-resource-group[0].name
  location            = var.location
  project-name        = "adsync"
  resource-prefixes   = var.resource-prefixes
  resource-suffixes   = ["001"]
  subnet-id           = module.identity-subnet.subnet-id
  ip-address          = cidrhost(module.identity-subnet.address-prefixes[0], (count.index + 7)) # Note: the first 3 IPs are reserved by Azure. So starting at 4.

  vm-size                       = var.adsync.vm-size
  support-hvic                  = var.adsync.vtpm-enabled
  update-management-integration = false
  enable-azuread-login          = false

  disk-encryption = {
    key-vault-url            = azurerm_key_vault.identity-key-vault.vault_uri
    key-vault-encryption-url = azurerm_key_vault_key.vm-ade-key-adsync[count.index].id
    key-vault-resource-id    = azurerm_key_vault.identity-key-vault.id
  }
  source-image-id = var.vm_source_image_id
}
