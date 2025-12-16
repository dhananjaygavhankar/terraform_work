# variable "vm_name" {
#   description = "Name of the Virtual Machine."
#   type        = string
#   default     = "frontend-vm"
# }

variable "vm_size" {
  description = "Size of the Virtual Machine."
  type        = string
  default     = "Standard_F2s_v2"
}
variable "vmss_sku" {
  description = "The SKU for the VMSS."
  type        = string
  default     = "Standard_F2s_v2"
}

variable "instance_count" {
  description = "Number of instances in the frontend VMSS."
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Admin username for the VMSS."
  type        = string
  default     = "azureuser"
}


variable "image_publisher" {
  description = "Image publisher."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Image offer."
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU."
  type        = string
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "Image version."
  type        = string
  default     = "latest"
}

variable "os_disk_type" {
  description = "OS disk storage account type."
  type        = string
  default     = "Standard_LRS"
}

variable "upgrade_mode" {
  description = "Upgrade mode for the VMSS."
  type        = string
  default     = "Manual"
}

variable "computer_name_prefix" {
  description = "Prefix for computer names."
  type        = string
  default     = "vmss"
}

variable "tags" {
  description = "Tags for the VMSS."
  type        = map(string)
  default     = {}
}
variable "backend_instance_count" {
  description = "Number of instances for backend VMSS."
  type        = number
  default     = 2
}
variable "Parent_prod_location_rg" {
  type = string
}
variable "Parent_prod_rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}
variable "subnets" {
  type = map(object({
    name = string
    cidr = string
  }))
}

variable "pip_name" {
  type = string
}

variable "admin_password" {
  description = "Admin password for the VMSS."
  type        = string
  default     = "Azureuser@1234567"
}

variable "LB_IP_Config" {
  description = "Name for the LB IP Configuration."
  type        = string
  default     = "LB_IP_config"
}
variable "bastion_subnet_address_prefixes" { type = list(string) }