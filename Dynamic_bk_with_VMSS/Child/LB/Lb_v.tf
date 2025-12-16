variable "rg_name" { type = string }
variable "location_rg" { type = string }
variable "LB_IP_Config" { type = string }
variable "LB_pip" { type = string }
variable "vnet_name" { type = string }
variable "nic_ids" { type = map(string) }