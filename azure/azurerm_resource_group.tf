resource "azurerm_resource_group" "main" {
  name     = "rg-${terraform.workspace}"
  location = "eastus"
}

output "resource_group_name" {
  description = "The resource group name"
  value       = azurerm_resource_group.main.name
}
