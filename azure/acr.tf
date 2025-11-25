resource "azurerm_container_registry" "acr" {
    location = azurerm_resource_group.main.location
    name = "acrgovtech${local.workspace_suffix}"
    resource_group_name = azurerm_resource_group.main.name
    sku = "Standard"
    admin_enabled = true
    public_network_access_enabled = true

    tags = {
        environment = local.workspace_suffix
        # src = var.src_key
    }
}