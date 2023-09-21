output "dns-servers" {
  value = var.vm_source_image_id == null ? module.adds-vm-marketplace[*].ip-address : module.adds-vm-gallery[*].ip-address
  description = "DNS servers IP addresses"
}

output "vnet-id" {
  value = module.landingzone.vnet-id
  description = "resource id of the hub vnet"
}