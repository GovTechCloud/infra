
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.workspace_suffix}"
  address_space       = [local.vnet_cidrs[local.workspace_suffix]]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "frontend" {
  name                 = "subnet-frontend-${local.workspace_suffix}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_frontend_cidrs[local.workspace_suffix]]
}

resource "azurerm_subnet" "backend" {
  name                 = "subnet-backend-${local.workspace_suffix}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_backend_cidrs[local.workspace_suffix]]
}

resource "azurerm_subnet" "db" {
  name                 = "subnet-db-${local.workspace_suffix}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_db_cidrs[local.workspace_suffix]]
}


output "virtual_network_name" {
  description = "The virtual network name"
  value       = azurerm_virtual_network.main.name
}

output "subnet_frontend_id" {
  description = "The ID of the frontend subnet"
  value       = azurerm_subnet.frontend.id
}

output "subnet_backend_id" {
  description = "The ID of the backend subnet"
  value       = azurerm_subnet.backend.id
}

output "subnet_db_id" {
  description = "The ID of the db subnet"
  value       = azurerm_subnet.db.id
}
