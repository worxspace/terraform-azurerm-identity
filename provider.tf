terraform {
  required_providers {
    azurerm = {
      version = ">=3.40.0"
    }
    azurecaf = {
      version = ">=2.0.0-preview3"
      source  = "aztfmod/azurecaf"
    }
    random = ">=3.4.3"
  }
}
