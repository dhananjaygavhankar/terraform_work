variable "vm_name" { type = string }
variable "rg_name" { type = string }
variable "location_rg" { type = string }
variable "admin_username" { type = string }
variable "disc_name" { type = string }
# variable "admin_ssh_public_key" { type = string }
variable "image_publisher" { type = string }
variable "image_offer" { type = string }
variable "image_sku" { type = string }
variable "image_version" { type = string }
variable "os_disk_type" { type = string }
variable "tags" { type = map(string) }
variable "vm_size" { type = string }
variable "nic_id" { type = string }
variable "admin_password" {
  description = "Admin password for the VMSS."
  type        = string
#   default     = "Azureuser@123456"
}