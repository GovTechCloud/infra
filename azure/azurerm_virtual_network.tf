
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${terraform.workspace}"
  address_space       = [local.vnet_cidrs[terraform.workspace]]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "frontend" {
  name                 = "subnet-frontend-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_frontend_cidrs[terraform.workspace]]
}

resource "azurerm_subnet" "backend" {
  name                 = "subnet-backend-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_backend_cidrs[terraform.workspace]]
}

resource "azurerm_subnet" "db" {
  name                 = "subnet-db-${terraform.workspace}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.subnet_db_cidrs[terraform.workspace]]
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
