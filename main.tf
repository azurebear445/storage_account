#------------------------------------------------------------------------------
# Data Sources
#------------------------------------------------------------------------------
data "azurerm_client_config" "current" {}

# Option 1: Use existing resource group (uncomment when needed)
# data "azurerm_resource_group" "main" {
#   name = var.resource_group_name
# }

#------------------------------------------------------------------------------
# Azure Storage Account
#------------------------------------------------------------------------------
resource "azurerm_storage_account" "this" {
  name                = local.storage_account_name
  resource_group_name = var.resource_group_name  # Direct reference for testing
  location            = var.location

  # If using existing resource group (Option 1), change above two lines to:
  # resource_group_name = data.azurerm_resource_group.main.name
  # location            = data.azurerm_resource_group.main.location

  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier

  tags = local.storage_account_tags
}

#------------------------------------------------------------------------------
# Azure Blob Container
#------------------------------------------------------------------------------
resource "azurerm_storage_container" "this" {
  name                  = local.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = var.container_access_type
}
