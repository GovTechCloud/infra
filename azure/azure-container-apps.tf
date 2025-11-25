resource "azurerm_container_app" "app" {
  container_app_environment_id = azurerm_container_app_environment.main-acae.id
  name                         = "aca-${local.workspace_suffix}"
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Multiple"

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      cpu    = 0.25
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      memory = "0.5Gi"
      name   = "stub"
    }

  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80

    traffic_weight {
      percentage      = 100
      label           = "primary"
      latest_revision = true
    }

  }

  lifecycle {
    ignore_changes = [ 
      template, 
      ingress, 
      registry, 
      secret,
     ]
  }

  tags = {
    environment = local.workspace_suffix
    # src         = var.src_key
  }
}
