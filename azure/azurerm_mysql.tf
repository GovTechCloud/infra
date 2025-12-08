resource "azurerm_mysql_flexible_server" "flexible_mysql" {
  name                   = "${terraform.workspace}-mysql-server"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = "8.0.21"
  administrator_login    = "adminuser"
  administrator_password = var.mysql_admin_password
  backup_retention_days  = 7 #1to 35 days  
  geo_redundant_backup_enabled   = false  
  sku_name               = "B_Standard_B1s"
  public_network_access = "Enabled"
  storage {
    auto_grow_enabled    = true
    iops                 = 640
    size_gb              = 20
  }
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_public_access" {
  name                = "AllowPublicAccess"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.flexible_mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
