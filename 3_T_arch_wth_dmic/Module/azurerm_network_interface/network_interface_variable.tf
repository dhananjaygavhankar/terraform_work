variable "rg_nam"{}
variable "locatio"{}

variable "subne_id"{}
variable "name_nic"{}

variable "public_ip_resource_id" {
  type    = string
  default = null
}

variable "private_ip_allocation_method" {
  type = string
  default = "Dynamic" 
}

# variable "rg_nam"{}
# variable "locatio"{}
# variable "subne_id"{}
# variable "name_nic"{}

# variable "public_ip_resource_id" {
#   type    = string
#   default = null
# }

# variable "private_ip_allocation_method" {
#   type    = string
#   # --- FIX: ADDING DEFAULT VALUE ---
#   default = "Dynamic" 
# }