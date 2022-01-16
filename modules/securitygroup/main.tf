resource "azurerm_application_security_group" "web-asg" {
  name                = "web-asg"
  location = var.location
  resource_group_name = var.resource_group

  tags = {
    asg = "web"
  }
}

resource "azurerm_application_security_group" "app-asg" {
  name                = "db-asg"
  location = var.location
  resource_group_name = var.resource_group

  tags = {
    asg = "app"
  }
}

resource "azurerm_application_security_group" "db-asg" {
  name                = "db-asg"
  location = var.location
  resource_group_name = var.resource_group

  tags = {
    asg = "db"
  }
}
resource "azurerm_network_security_group" "web-nsg" {
  name                = "web-nsg"
  location            = var.location
  resource_group_name = var.resource_group
  
  security_rule {
    name                       = "ssh-rule-1"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
  }
  
  security_rule {
    name                       = "ssh-rule-2"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_address_prefix      = "192.168.3.0/24"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
}
}

resource "azurerm_subnet_network_security_group_association" "web-nsg-subnet" {
  subnet_id                 = var.web_subnet_id
  network_security_group_id = azurerm_network_security_group.web-nsg.id
}


resource "azurerm_network_security_group" "app-nsg" {
    name = "app-nsg"
    location = var.location
    resource_group_name = var.resource_group

    security_rule {
        name = "ssh-rule-1"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        #source_address_prefix = "192.168.1.0/24"
        source_application_security_group_ids = [azurerm_application_security_group.app-asg.id]
        source_port_range = "*"
        #destination_address_prefix = "*"
        destination_application_security_group_ids = [azurerm_application_security_group.db-asg.id]
        destination_port_range = "22"
    }
    
    security_rule {
        name = "ssh-rule-2"
        priority = 101
        direction = "Outbound"
        access = "Allow"
        protocol = "Tcp"
        #source_address_prefix = "192.168.1.0/24"
        source_application_security_group_ids = [azurerm_application_security_group.web-asg.id]
        source_port_range = "*"
        destination_application_security_group_ids = [azurerm_application_security_group.app-asg.id]
        #destination_address_prefix = "*"
        destination_port_range = "22"
    }
}

resource "azurerm_subnet_network_security_group_association" "app-nsg-subnet" {
  subnet_id                 = var.app_subnet_id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}


resource "azurerm_network_security_group" "db-nsg" {
    name = "db-nsg"
    location = var.location
    resource_group_name = var.resource_group

    security_rule {
        name = "ssh-rule-1"
        priority = 101
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "192.168.2.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "3306"
    }
    
    security_rule {
        name = "ssh-rule-2"
        priority = 102
        direction = "Outbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "192.168.2.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "3306"
    }
    
    security_rule {
        name = "ssh-rule-3"
        priority = 100
        direction = "Outbound"
        access = "Deny"
        protocol = "Tcp"
        source_address_prefix = "192.168.1.0/24"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_range = "3306"
    }
}

resource "azurerm_subnet_network_security_group_association" "db-nsg-subnet" {
  subnet_id                 = var.db_subnet_id
  network_security_group_id = azurerm_network_security_group.db-nsg.id
}


