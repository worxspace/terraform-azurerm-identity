# tfm-azure-identity

Creates ADDS landing zone in azure in a standardised way using the latest recommendations.

We use azurecaf\_name to generate a unique name for the user assigned identity.
so make sure to provide the project-name, prefixes, suffixes as necessary

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >=2.0.0-preview3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.40.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | >=2.0.0-preview3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.40.0 |
| <a name="provider_azurerm.Connectivity"></a> [azurerm.Connectivity](#provider\_azurerm.Connectivity) | >=3.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adds-vm"></a> [adds-vm](#module\_adds-vm) | github.com/worxspace/tfm-azure-vm-windows | v0.3 |
| <a name="module_adsync-vm"></a> [adsync-vm](#module\_adsync-vm) | github.com/worxspace/tfm-azure-vm-windows | v0.3 |
| <a name="module_identity-subnet"></a> [identity-subnet](#module\_identity-subnet) | github.com/worxspace/tfm-azure-subnet | 0.0.2 |
| <a name="module_landingzone"></a> [landingzone](#module\_landingzone) | github.com/worxspace/tfm-azure-landingzone | 0.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.adds-resource-group-name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.adsync-resource-group-name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.identity-name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.vm-ade-key-adds](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.vm-ade-key-adsync](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
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
| <a name="input_address-space"></a> [address-space](#input\_address-space) | address space of the virtual network for this landing zone | `list(string)` | n/a | yes |
| <a name="input_adsync"></a> [adsync](#input\_adsync) | attributes for the adsync virtual machine | <pre>object({<br>    vm-size = optional(string, "Standard_B2s")<br>  })</pre> | `null` | no |
| <a name="input_domain-controller"></a> [domain-controller](#input\_domain-controller) | attributes for the domain controller virtual machines | <pre>object({<br>    vm-size           = optional(string, "Standard_D2s_V2")<br>    high-availability = optional(bool, true)<br>  })</pre> | `null` | no |
| <a name="input_firewall-ip"></a> [firewall-ip](#input\_firewall-ip) | ip address of the firewall used for forward subnet traffic to the internet | `string` | n/a | yes |
| <a name="input_hub-vnet"></a> [hub-vnet](#input\_hub-vnet) | attributes identifying the hub virtual network | <pre>object({<br>    name                = string<br>    resource-group-name = string<br>    id                  = string<br>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | value for the location of the virtual machines | `string` | `"switzerlandnorth"` | no |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | used as the main part of the name of the virtual machine | `string` | n/a | yes |
| <a name="input_resource-group-name"></a> [resource-group-name](#input\_resource-group-name) | resource group where you want to create the virtual machines | `string` | n/a | yes |
| <a name="input_resource-prefixes"></a> [resource-prefixes](#input\_resource-prefixes) | these are prefixed to resource names and usually include the tenant short name and/or the environment name | `list(string)` | `[]` | no |
| <a name="input_resource-suffixes"></a> [resource-suffixes](#input\_resource-suffixes) | these are appended to resource names and usually include the numbers when multiple resource with the same name exist | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns-servers"></a> [dns-servers](#output\_dns-servers) | DNS servers IP addresses |
