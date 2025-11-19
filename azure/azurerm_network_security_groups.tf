resource "azurerm_network_security_group" "public" {
  name                = "nsg-public-${local.workspace_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowPublicToService"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080" # Assuming backend runs on port 8080
    source_address_prefix      = azurerm_subnet.public.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.service.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.public.address_prefixes[0]
    destination_address_prefix = "Internet"
  }

  # Rules for public access (comment to make private)
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 100 # 100 (minimum allowed)
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = azurerm_subnet.public.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 101 # 101 (higher than 100, still lower than 200)
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = azurerm_subnet.public.address_prefixes[0]
  }
  # End public access

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
    name                       = "DenyPublicToData"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.public.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.data.address_prefixes[0]
  }
}

resource "azurerm_network_security_group" "service" {
  name                = "nsg-service-${local.workspace_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowPublicToServiceInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080" # Assuming service runs on port 8080
    source_address_prefix      = azurerm_subnet.public.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.service.address_prefixes[0]
  }

  security_rule {
    name                       = "AllowServiceToData"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433" # Assuming Azure SQL Database on port 1433
    source_address_prefix      = azurerm_subnet.service.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.data.address_prefixes[0]
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
    name                       = "DenyServiceOutboundInternet"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = azurerm_subnet.service.address_prefixes[0]
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_group" "data" {
  name                = "nsg-data-${local.workspace_suffix}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowServiceToDataInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433" # Assuming Azure SQL Database on port 1433
    source_address_prefix      = azurerm_subnet.service.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.data.address_prefixes[0]
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

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "service" {
  subnet_id                 = azurerm_subnet.service.id
  network_security_group_id = azurerm_network_security_group.service.id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}
