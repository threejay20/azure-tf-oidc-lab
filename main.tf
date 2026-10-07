data "azurerm_resource_group" "lab" {
  name = "rg-lab-tf"
}

locals {
  location = data.azurerm_resource_group.lab.location
  rg_name  = data.azurerm_resource_group.lab.name

  tags = {
    project    = "azure-tf-oidc-lab"
    managed_by = "terraform"
    owner      = "threejay20"
  }
}

resource "azurerm_virtual_network" "lab" {
  name                = "vnet-tf-lab"
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = ["10.20.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "apps" {
  name                 = "snet-apps"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_security_group" "apps" {
  name                = "nsg-apps"
  location            = local.location
  resource_group_name = local.rg_name
  tags                = local.tags

  security_rule {
    name                       = "deny-internet-inbound"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "apps" {
  subnet_id                 = azurerm_subnet.apps.id
  network_security_group_id = azurerm_network_security_group.apps.id
}

resource "azurerm_user_assigned_identity" "chatbot" {
  name                = "id-chatbot"
  location            = local.location
  resource_group_name = local.rg_name
  tags                = local.tags
}

resource "azurerm_subnet" "data" {
  name                 = "snet-data"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.20.2.0/24"]
}
