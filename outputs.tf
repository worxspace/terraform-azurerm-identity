output "dns-servers" {
  value = module.adds-vm[*].ip-address
  description = "DNS servers IP addresses"
}
