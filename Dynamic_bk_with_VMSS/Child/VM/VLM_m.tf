

# resource "azurerm_linux_virtual_machine" "this" {
#   # for_each = var.subnets
#   name                = var.vm_name
#   # name                = "${each.value.name}-vm"
#   resource_group_name = var.rg_name
#   location            = var.location_rg
#   size                = var.vm_size
#   admin_username      = var.admin_username
#   network_interface_ids = [var.nic_id]

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = var.admin_ssh_public_key
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = var.os_disk_type
#   }

#   source_image_reference {
#     publisher = var.image_publisher
#     offer     = var.image_offer
#     sku       = var.image_sku
#     version   = var.image_version
#   }

#   tags = var.tags
# }

