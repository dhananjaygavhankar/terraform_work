resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = var.location_rg
  resource_group_name   = var.rg_name
  network_interface_ids = [var.nic_id]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  storage_os_disk {
    name              = var.disc_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.os_disk_type
  }
  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
   
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = var.tags
}
