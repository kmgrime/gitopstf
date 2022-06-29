terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        vversion = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  location = "uksouth"
  prefix = "gitopsdemo"
}

resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg"
  location = local.location
  }

resource "azurerm_storage_account" "main" {
  name                     = "${local.prefix}storageacct"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "main" {
  name                = "${local.prefix}-asp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type            = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "main" {
  name                       = "${local.prefix}-function"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location

  service_plan_id            = azurerm_service_plan.main.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  site_config {}
}
