# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "web_test" {
  name     = "web_test"
  location = "${var.location}"
}

# Create a virtual network in the web_test resource group
resource "azurerm_virtual_network" "web_test_network" {
  name                = "web_test_network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.web_test.name}"
}

# create a subnet
resource "azurerm_subnet" "web_test_network_subnet_1" {
  name                 = "wtns_1"
  resource_group_name  = "${azurerm_resource_group.web_test.name}"
  virtual_network_name = "${azurerm_virtual_network.web_test_network.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a public IP addr
resource "azurerm_public_ip" "web_test_ip" {
  name                         = "web_test_ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.web_test.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "TerraformDemo"
  }
}

# Create network interface
resource "azurerm_network_interface" "web_test_nic" {
  name                = "tfni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.web_test.name}"

  ip_configuration {
    name                          = "wt_config_1"
    subnet_id                     = "${azurerm_subnet.web_test_network_subnet_1.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = "${azurerm_public_ip.web_test_ip.id}"
  }
}

# Create storage account
resource "azurerm_storage_account" "web_test_storage" {
  name                = "webteststorageehron"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.web_test.name}"
  account_type        = "Standard_LRS"

  tags {
    environment = "staging"
  }
}

# Create storage container
resource "azurerm_storage_container" "web_test_storage_container" {
  name                  = "vhd"
  resource_group_name   = "${azurerm_resource_group.web_test.name}"
  storage_account_name  = "${azurerm_storage_account.web_test_storage.name}"
  container_access_type = "private"
  depends_on            = ["azurerm_storage_account.web_test_storage"]
}

# Create virtual machine
resource "azurerm_virtual_machine" "server" {
  name                  = "server"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.web_test.name}"
  network_interface_ids = ["${azurerm_network_interface.web_test_nic.id}"]
  vm_size               = "Standard_A0"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "server_disk"
    vhd_uri       = "${azurerm_storage_account.web_test_storage.primary_blob_endpoint}${azurerm_storage_container.web_test_storage_container.name}/myosdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "server"
    admin_username = "ehron"
    admin_password = "Abc123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}
