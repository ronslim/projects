provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "teststorage082022" {
  name                     = "teststorage082022"
  resource_group_name      = "learn-bef1708a-a461-465d-bf0d-855370cf5bc4"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}