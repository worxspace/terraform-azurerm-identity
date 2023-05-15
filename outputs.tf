output "dns-servers" {
  value = module.adds-vm[*].ip-address
  description = "DNS servers IP addresses"
}

output "vnet-id" {
  value = module.landingzone.vnet-id
  description = "resource id of the hub vnet"
}