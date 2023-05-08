resource "azurecaf_name" "identity-name" {
  resource_types = [
    "azurerm_resource_group",
    "azurerm_key_vault"
  ]
  name     = var.project-name
  prefixes = var.resource-prefixes
  suffixes = var.resource-suffixes
}

resource "azurerm_resource_group" "identity-resource-group" {
  name     = azurecaf_name.identity-name.results.azurerm_resource_group
  location = var.location
}

resource "azurerm_key_vault" "identity-key-vault" {
  name                        = azurecaf_name.identity-name.results.azurerm_key_vault
  resource_group_name         = azurerm_resource_group.identity-resource-group.name
  location                    = var.location
  sku_name                    = "standard"
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization   = true
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
}

resource "azurerm_role_assignment" "identity-key-vault-current-officer" {
  scope                = azurerm_key_vault.identity-key-vault.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
}
