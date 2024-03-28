# variable "admin_username" {
#   description = "The username for the administrator of the Virtual Machine"
# }

# variable "admin_password" {
#   description = "The password for the administrator of the Virtual Machine"
# }

# variable "location" {
#   description = "The Azure region in which to create the Virtual Machine"
# }

# variable "vm_name" {
#   description = "The name of the Virtual Machine"
# }

# variable "resource_group_name" {
#   description = "The name of the resource group in which to create the Virtual Machine"
# }

# variable "virtual_network_name" {
#   description = "The name of the virtual network in which to place the Virtual Machine"
# }

# variable "subnet_name" {
#   description = "The name of the subnet in which to place the Virtual Machine"
# }

# variable "public_ip_name" {
#   description = "The name of the public IP address to associate with the Virtual Machine"
# }

provider "azurerm" {
  features {}
}

# resource "azurerm_resource_group" "main" {
#   name     = var.resource_group_name
#   location = var.location
# }

# resource "azurerm_virtual_network" "main" {
#   name                = var.virtual_network_name
#   resource_group_name = azurerm_resource_group.main.name
#   location            = var.location
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "main" {
#   name                 = var.subnet_name
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_public_ip" "main" {
#   name                = var.public_ip_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.main.name
#   allocation_method   = "Dynamic"
# }

# resource "azurerm_network_interface" "main" {
#   name                = "${var.vm_name}-nic"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "ipconfig1"
#     subnet_id                     = azurerm_subnet.main.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.main.id
#   }
# }

# resource "azurerm_linux_virtual_machine" "main" {
#   name                = var.vm_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.main.name
#   size                = "Standard_E2s_v5"
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   network_interface_ids = [azurerm_network_interface.main.id]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = 64
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file("/root/vscode/workspace/homelab/terraform/PublicKey_Ansible.txt")
#   }
# }

# output "public_ip_address" {
#   value = azurerm_public_ip.main.ip_address
# }