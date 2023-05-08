output "dns-servers" {
  value = module.adds-vm[*].ip-address
}
