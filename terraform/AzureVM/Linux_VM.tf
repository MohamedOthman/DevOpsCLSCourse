# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "mygroup" {
    name     = "myResourceGroup"
    location = "eastus"

    tags {
        environment = "test environment"
        purpose = "training"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "internal_vn" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.mygroup.name}"

    tags {
        environment = "test environment"
        purpose = "training"
    }
}

# Create subnet
resource "azurerm_subnet" "internal_subnet" {
    name                 = "myInternalSubnet"
    resource_group_name  = "${azurerm_resource_group.mygroup.name}"
    virtual_network_name = "${azurerm_virtual_network.internal_vn.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "publicip_dev" {
    name                         = "publicip_dev"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.mygroup.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "test environment"
        purpose = "training"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "mainsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.mygroup.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "RDP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "test environment"
        purpose = "training"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic1" {
    name                      = "NIC1"
    location                  = "eastus"
    resource_group_name       = "${azurerm_resource_group.mygroup.name}"
    network_security_group_id = "${azurerm_network_security_group.mainsg.id}"

    ip_configuration {
        name                          = "NicConfiguration1"
        subnet_id                     = "${azurerm_subnet.internal_subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicip_dev.id}"
    }

    tags {
        environment = "test environment"
        purpose = "training"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.mygroup.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "dev_storage" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.mygroup.name}"
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "test environment"
        purpose = "training"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "DevLinuxVM"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.mygroup.name}"
    network_interface_ids = ["${azurerm_network_interface.nic1.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "DevLinuxVM"
        admin_username = "azureuser"
        admin_password = "Password1234!"
    }
    os_profile_linux_config {
    disable_password_authentication = false
  }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.dev_storage.primary_blob_endpoint}"
    }
    tags {
        environment = "test environment"
        purpose = "training"
    }
}
