
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "capigroup"
}


resource "azurerm_servicebus_namespace" "capi-service-bus" {
  name                = "capi-service-bus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = "capigroup"
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}


resource "azurerm_servicebus_queue" "client-que" {
  name         = "client-que"
  namespace_id = azurerm_servicebus_namespace.capi-service-bus.id

  enable_partitioning = true
}



resource "azurerm_storage_account" "capiapistorage" {
  name                     = "capiapistorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_service_plan" "capiserviceplan" {
  name                = "capiserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
}



resource "azurerm_linux_function_app" "capifunction" {
  name                = "capifunction"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.capiserviceplan.id

  storage_account_name       = azurerm_storage_account.capiapistorage.name
  storage_account_access_key = azurerm_storage_account.capiapistorage.primary_access_key

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}