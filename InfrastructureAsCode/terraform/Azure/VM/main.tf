provider "azurerm" {
  features {}
}

# Create virtual network
resource "azurerm_virtual_network" "myvnet" {
  name                = "test-vp-vm2-vnet"
  address_space       = ["172.16.0.0/16"]
  location            = "westus"
  resource_group_name = "learn-bbb8ac88-ed01-42c1-a339-103af1464d8d"
}

# Create subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "test-vp-vm2-subnet"
  resource_group_name  = "learn-bbb8ac88-ed01-42c1-a339-103af1464d8d"
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "mypublicip" {
  name                = "test-vp-vm2-public-ip"
  location            = "westus"
  resource_group_name = "learn-bbb8ac88-ed01-42c1-a339-103af1464d8d"
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "mynsg" {
  name                = "test-vp-vm2-nsg"
  location            = "westus"
  resource_group_name = "learn-bbb8ac88-ed01-42c1-a339-103af1464d8d"

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "mynic" {
  name                = "test-vp-vm2-nic"
  location            = "westus"
  resource_group_name = "learn-bbb8ac88-ed01-42c1-a339-103af1464d8d"

  ip_configuration {
    name                          = "test-vp-vm2-nicconfig"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}


# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "test-vp-vm2"
  admin_username        = "azureadmin"
  admin_password        = "Milo082023"
  location              = "westus"
  resource_group_name   = "learn-bbb8ac88-ed01-42c1-a339-103af1464d8d"
  network_interface_ids = [azurerm_network_interface.mynic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }
}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "test-vp-vm2-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = false

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
}