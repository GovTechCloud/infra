resource "azurerm_network_security_group" "frontend" {
  name                = "nsg-frontend-${local.workspace_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                   = "AllowFrontendToBackend"
    priority               = 100
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "8080" # Assuming backend runs on port 8080
    source_address_prefix  = azurerm_subnet.frontend.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.backend.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.frontend.address_prefixes[0]
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyFrontendToDB"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.frontend.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db.address_prefixes[0]
  }
}

resource "azurerm_network_security_group" "backend" {
  name                = "nsg-backend-${local.workspace_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                   = "AllowFrontendToBackendInbound"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "8080" # Assuming backend runs on port 8080
    source_address_prefix  = azurerm_subnet.frontend.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.backend.address_prefixes[0]
  }

  security_rule {
    name                   = "AllowBackendToDB"
    priority               = 110
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "1433" # Assuming Azure SQL Database on port 1433
    source_address_prefix  = azurerm_subnet.backend.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db.address_prefixes[0]
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyBackendOutboundInternet"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.backend.address_prefixes[0]
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg-db-${local.workspace_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                   = "AllowBackendToDBInbound"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "1433" # Assuming Azure SQL Database on port 1433
    source_address_prefix  = azurerm_subnet.backend.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db.address_prefixes[0]
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 1000 # High priority to ensure it overrides other outbound rules
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = azurerm_network_security_group.frontend.id
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = azurerm_subnet.backend.id
  network_security_group_id = azurerm_network_security_group.backend.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}
