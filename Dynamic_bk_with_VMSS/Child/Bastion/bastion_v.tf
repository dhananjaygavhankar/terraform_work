variable "rg_name" { type = string }
variable "location_rg" { type = string }
variable "vnet_name" { type = string }
variable "bastion_subnet_address_prefixes" { type = list(string) }
variable "bastion_Pip_id" { type = string }