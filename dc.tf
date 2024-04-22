resource "azurecaf_name" "adds-resource-group-name" {
  resource_type = "azurerm_resource_group"
  name          = "${var.project-name}_adds"
  prefixes      = var.resource-prefixes
  suffixes      = concat(var.resource-suffixes, ["001"])
}

resource "azurerm_resource_group" "adds-resource-group" {
  name     = azurecaf_name.adds-resource-group-name.result
  location = var.location
}

resource "azurecaf_name" "adds-avail-name" {
  resource_type = "azurerm_availability_set"
  name          = "${var.project-name}_adds"
  prefixes      = var.resource-prefixes
  suffixes      = concat(var.resource-suffixes, ["001"])
}

resource "azurerm_availability_set" "adds" {
  name                = azurecaf_name.adds-avail-name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.adds-resource-group.name

  platform_fault_domain_count = 2
}

resource "azurecaf_name" "vm-ade-key-adds" {
  count = var.domain-controller == null ? 0 : var.domain-controller.high-availability == true ? 2 : 1

  resource_type = "azurerm_key_vault_key"

  name     = "adds"
  prefixes = var.resource-prefixes
  suffixes = concat(["vm${format("%03d", count.index + 1)}"], var.resource-suffixes)
}

resource "azurerm_key_vault_key" "vm-ade-key-adds" {
  count = var.domain-controller == null ? 0 : var.domain-controller.high-availability == true ? 2 : 1

  name         = azurecaf_name.vm-ade-key-adds[count.index].result
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

module "adds-vm-marketplace" {
  source  = "app.terraform.io/worxspace/vm-windows/azurerm"
  version = "~>1.0.0"

  count = var.vm_source_image_id != null ? 0 : var.domain-controller == null ? 0 : var.domain-controller.high-availability == true ? 2 : 1

  resource-group-name = azurerm_resource_group.adds-resource-group.name
  location            = var.location
  project-name        = "adds"
  resource-prefixes   = var.resource-prefixes
  resource-suffixes   = [format("%03d", count.index + 1)]
  machine-index       = count.index + 1
  subnet-id           = module.landingzone.subnets["identity"].subnet-id
  ip-address          = cidrhost(module.landingzone.subnets["identity"].address-prefixes[0], (count.index + 4)) # Note: the first 3 IPs are reserved by Azure. So starting at 4.

  vm-size                       = var.domain-controller.vm-size
  support-hvic                  = var.domain-controller.vtpm-enabled
  update-management-integration = false
  enable-azuread-login          = false
  availability_set_id           = azurerm_availability_set.adds.id
  os-disk-storage-type          = "StandardSSD_LRS"

  data-disks = [{
    name         = "addata"
    size-gb      = 10
    storage-type = "Premium_LRS"
    tier         = "P3"
  }]

  disk-encryption = {
    key-vault-url            = azurerm_key_vault.identity-key-vault.vault_uri
    key-vault-encryption-url = azurerm_key_vault_key.vm-ade-key-adds[count.index].id
    key-vault-resource-id    = azurerm_key_vault.identity-key-vault.id
  }
}

module "adds-vm-gallery" {
  source  = "app.terraform.io/worxspace/vm-windows/azurerm"
  version = "~>1.0.0"

  count = var.vm_source_image_id != null && var.domain-controller == null ? 0 : var.domain-controller.high-availability == true ? 2 : 1

  resource-group-name = azurerm_resource_group.adds-resource-group.name
  location            = var.location
  project-name        = "adds"
  resource-prefixes   = var.resource-prefixes
  resource-suffixes   = var.resource-suffixes
  machine-index       = count.index + 1
  subnet-id           = module.landingzone.subnets["identity"].subnet-id
  ip-address          = cidrhost(module.landingzone.subnets["identity"].address-prefixes[0], (count.index + 4)) # Note: the first 3 IPs are reserved by Azure. So starting at 4.

  vm-size                       = var.domain-controller.vm-size
  support-hvic                  = var.domain-controller.vtpm-enabled
  update-management-integration = false
  enable-azuread-login          = false
  availability_set_id           = azurerm_availability_set.adds.id
  os-disk-storage-type          = "StandardSSD_LRS"

  data-disks = [{
    name         = "addata"
    size-gb      = 10
    storage-type = "Premium_LRS"
    tier         = "P3"
  }]

  disk-encryption = {
    key-vault-url            = azurerm_key_vault.identity-key-vault.vault_uri
    key-vault-encryption-url = azurerm_key_vault_key.vm-ade-key-adds[count.index].id
    key-vault-resource-id    = azurerm_key_vault.identity-key-vault.id
  }

  source-image-id = var.vm_source_image_id
}
