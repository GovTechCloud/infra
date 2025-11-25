resource "azurerm_container_app_environment" "main-acae" {
  location                   = azurerm_resource_group.main.location
  name                       = "acae-${local.workspace_suffix}"
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main-law.id

  tags = {
    environment = local.workspace_suffix
    # src = var.src_key
  }
}