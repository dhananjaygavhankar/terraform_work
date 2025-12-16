resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name_vm
  resource_group_name = var.rg_nam
  location            = var.locatio
  size                =var.size
  admin_username      =var.admin_username
  admin_password =var.admin_password
  custom_data = var.custom_data
  network_interface_ids =var.network_interface_ids

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }
  disable_password_authentication = false 


  os_disk {
    caching              =var.os_disk.caching 
    storage_account_type =var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher =var.source_image_reference.publisher
    offer     =var.source_image_reference.offer
    sku       =var.source_image_reference.sku
    version   =var.source_image_reference.version
  }
}


output "vm_ids" {
  value = azurerm_linux_virtual_machine.vm.id
}