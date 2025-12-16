output "subnet_output_map" {
  value = module.vnet.subnet_output_map
}

output "pip_id" {
  value = module.pip.pip_id
}
output "nic_ids" {
  value = module.nic.nic_ids
}

output "nsg_id" {
  value = module.nsg.nsg_id
}