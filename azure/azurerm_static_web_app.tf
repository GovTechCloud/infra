resource "azurerm_static_web_app" "main" {
  name                = "swa-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    environment = terraform.workspace
  }
}

output "static_web_app_default_hostname" {
  description = "The default hostname of the Static Web App"
  value       = azurerm_static_web_app.main.default_host_name
}
