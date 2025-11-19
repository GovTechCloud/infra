
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.workspace_suffix}"
  address_space       = [local.vnet_cidrs[local.workspace_suffix]]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "public" {
  name                 = "subnet-public-${local.workspace_suffix}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_public_cidrs[local.workspace_suffix]]
}

resource "azurerm_subnet" "service" {
  name                 = "subnet-service-${local.workspace_suffix}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_service_cidrs[local.workspace_suffix]]
}

resource "azurerm_subnet" "data" {
  name                 = "subnet-data-${local.workspace_suffix}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_data_cidrs[local.workspace_suffix]]
}


output "virtual_network_name" {
  description = "The virtual network name"
  value       = azurerm_virtual_network.main.name
}

output "subnet_public_id" {
  description = "The ID of the public subnet"
  value       = azurerm_subnet.public.id
}

output "subnet_service_id" {
  description = "The ID of the service subnet"
  value       = azurerm_subnet.service.id
}

output "subnet_dat-id" {
  description = "The ID of the data subnet"
  value       = azurerm_subnet.data.id
}
