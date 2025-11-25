resource "azurerm_log_analytics_workspace" "my-nu-masternet-eus-law" {
    location = azurerm_resource_group.main.location
    name = "law-${local.workspace_suffix}"
    resource_group_name = azurerm_resource_group.main.name
    sku = "PerGB2018"
    retention_in_days = 30
}