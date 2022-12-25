terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.36.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure_infra" {
  name     = "azure_infra"
  location = "West Europe"
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public_IP_for_fe"
  resource_group_name = azurerm_resource_group.azure_infra.name
  location            = azurerm_resource_group.azure_infra.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_network" "virtual-network" {
  name                = "virtual-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.azure_infra.location
  resource_group_name = azurerm_resource_group.azure_infra.name
}

resource "azurerm_subnet" "subnetbe01" {
  name                 = "subnetbe01"
  resource_group_name  = azurerm_resource_group.azure_infra.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.0.0.0/25"]
}

resource "azurerm_subnet" "subnetfe01" {
  name                 = "subnetfe01"
  resource_group_name  = azurerm_resource_group.azure_infra.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.0.0.128/25"]
}

resource "azurerm_network_interface" "NICfe01" {
  name                = "NICfe01"
  location            = azurerm_resource_group.azure_infra.location
  resource_group_name = azurerm_resource_group.azure_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetfe01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface" "NICbe01" {
  name                = "NICbe01"
  location            = azurerm_resource_group.azure_infra.location
  resource_group_name = azurerm_resource_group.azure_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "NICbe02" {
  name                = "NICbe02"
  location            = azurerm_resource_group.azure_infra.location
  resource_group_name = azurerm_resource_group.azure_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "NICbe03" {
  name                = "NICbe03"
  location            = azurerm_resource_group.azure_infra.location
  resource_group_name = azurerm_resource_group.azure_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetbe01.id
    private_ip_address_allocation = "Dynamic"
  }
}