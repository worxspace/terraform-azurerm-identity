# tfm-azure-identity

Creates ADDS landing zone in azure in a standardised way using the latest recommendations.

We use azurecaf\_name to generate a unique name for the user assigned identity.
so make sure to provide the project-name, prefixes, suffixes as necessary

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | 2.0.0-preview3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.40.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 2.0.0-preview3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.40.0 |
| <a name="provider_azurerm.Connectivity"></a> [azurerm.Connectivity](#provider\_azurerm.Connectivity) | >=3.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adds-vm"></a> [adds-vm](#module\_adds-vm) | github.com/worxspace/tfm-azure-vm-windows | v0.3 |
| <a name="module_adsync-vm"></a> [adsync-vm](#module\_adsync-vm) | github.com/worxspace/tfm-azure-vm-windows | v0.3 |
| <a name="module_identity-subnet"></a> [identity-subnet](#module\_identity-subnet) | github.com/worxspace/tfm-azure-subnet | 0.0.1 |
| <a name="module_landingzone"></a> [landingzone](#module\_landingzone) | github.com/worxspace/tfm-azure-landingzone | 0.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.adds-resource-group-name](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurecaf_name.adsync-resource-group-name](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurecaf_name.identity-name](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurecaf_name.vm-ade-key-adds](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurecaf_name.vm-ade-key-adsync](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurerm_key_vault.identity-key-vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.vm-ade-key-adds](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.vm-ade-key-adsync](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_resource_group.adds-resource-group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.adsync-resource-group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.identity-resource-group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.identity-key-vault-current-officer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_network_dns_servers.hub-dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_virtual_network_dns_servers.identity-dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address-space"></a> [address-space](#input\_address-space) | n/a | `list(string)` | n/a | yes |
| <a name="input_adsync"></a> [adsync](#input\_adsync) | n/a | <pre>object({<br>    vm-size = optional(string, "Standard_B2s")<br>  })</pre> | `null` | no |
| <a name="input_domain-controller"></a> [domain-controller](#input\_domain-controller) | n/a | <pre>object({<br>    vm-size           = optional(string, "Standard_D2s_V2")<br>    high-availability = optional(bool, true)<br>  })</pre> | `null` | no |
| <a name="input_firewall-ip"></a> [firewall-ip](#input\_firewall-ip) | n/a | `string` | n/a | yes |
| <a name="input_hub-vnet"></a> [hub-vnet](#input\_hub-vnet) | n/a | <pre>object({<br>    name                = string<br>    resource-group-name = string<br>    id                  = string<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"switzerlandnorth"` | no |
| <a name="input_tenant-name"></a> [tenant-name](#input\_tenant-name) | n/a | `string` | n/a | yes |
| <a name="input_tenant-short-name"></a> [tenant-short-name](#input\_tenant-short-name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns-servers"></a> [dns-servers](#output\_dns-servers) | n/a |
