resource "azurerm_resource_group" "rg1" {
    name = "prodrg"
    location = "east us"
    tags = {
      "env" = "tail"
    }
    
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "prodvnet"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "prodsubnet" {
name                 = "prodsubnet01"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
  
}

resource "azurerm_network_security_group" "nsg" {
  name                = "prodnsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

  resource "azurerm_network_security_rule" "nsgrule" {
  name                        = "prodrule"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.nsg.name

  }

resource "azurerm_public_ip" "pip" {
  name                = "prodpip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_managed_disk" "azuredisk" {
  name                 = "proddisk"
  location             = azurerm_resource_group.rg1.location
  resource_group_name  = azurerm_resource_group.rg1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_network_interface" "prodnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prodsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = "winvm"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_F2"
  admin_username      = "suresh"
  admin_password      = "!!Testin12345"
  network_interface_ids = [azurerm_network_interface.prodnic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}