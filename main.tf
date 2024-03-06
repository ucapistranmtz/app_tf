
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "capigroup"
}


resource "azurerm_storage_account" "capiapistorage" {
  name                     = "capiapistorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blobcontainer" {
  name                  = "blobcontainer"
  storage_account_name  = azurerm_storage_account.capiapistorage.name
  container_access_type = "private"
}