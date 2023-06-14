resource "azurecaf_name" "adsync-resource-group-name" {
  resource_type = "azurerm_resource_group"
  name          = "${var.project-name}-adsync"
  prefixes      = var.resource-prefixes
  suffixes      = var.resource-suffixes
}

resource "azurerm_resource_group" "adsync-resource-group" {
  name     = azurecaf_name.adsync-resource-group-name.result
  location = var.location
}

resource "azurecaf_name" "vm-ade-key-adsync" {
  count = var.adsync == null ? 0 : 1

  resource_type = "azurerm_key_vault_key"
  name          = "${var.project-name}-adsync"
  prefixes      = var.resource-prefixes
  suffixes      = concat(["vm-${count.index}"], var.resource-suffixes)
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

module "adsync-vm" {
  source  = "app.terraform.io/worxspace/vm-windows/azurerm"
  version = "~>0.0.5"

  depends_on = [
    azurerm_role_assignment.identity-key-vault-current-officer
  ]
  count = var.adsync == null ? 0 : 1

  resource-group-name = azurerm_resource_group.adsync-resource-group.name
  location            = var.location
  project-name        = "adsync"
  resource-prefixes   = var.resource-prefixes
  subnet-id           = module.identity-subnet.subnet-id
  ip-address          = cidrhost(module.identity-subnet.address-prefixes[0], (count.index + 7)) # Note: the first 3 IPs are reserved by Azure. So starting at 4.

  vm-size              = var.domain-controller.vm-size
  support-hvic         = true
  enable-azuread-login = false

  disk-encryption = {
    key-vault-url            = azurerm_key_vault.identity-key-vault.vault_uri
    key-vault-encryption-url = azurerm_key_vault_key.vm-ade-key-adsync[count.index].id
    key-vault-resource-id    = azurerm_key_vault.identity-key-vault.id
  }
}
