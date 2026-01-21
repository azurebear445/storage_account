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
  resource_group_name = var.resource_group_name # Direct reference for testing
  location            = var.location

  # If using existing resource group (Option 1), change above two lines to:
  # resource_group_name = data.azurerm_resource_group.main.name
  # location            = data.azurerm_resource_group.main.location

  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier

  #----------------------------------------------------------------------------
  # Security Settings (Story 1B)
  #----------------------------------------------------------------------------

  # HTTPS-only enforcement (replicates AWS force_https_uploads policy)
  https_traffic_only_enabled = var.enable_https_traffic_only

  # Minimum TLS version (default: TLS1_2)
  min_tls_version = var.min_tls_version

  # Shared access key - disable if using only Azure AD authentication
  shared_access_key_enabled = var.shared_access_key_enabled

  #----------------------------------------------------------------------------
  # Blob Properties - Versioning and Soft Delete (Story 1B)
  #----------------------------------------------------------------------------
  blob_properties {
    # Blob versioning (replicates AWS S3 versioning)
    versioning_enabled = var.enable_versioning

    # Soft delete for blobs - allows recovery of deleted blobs
    delete_retention_policy {
      days = var.soft_delete_retention_days
    }

    # Soft delete for containers - allows recovery of deleted containers
    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
  }

  #----------------------------------------------------------------------------
  # Customer-Managed Key Encryption (CMK) via Key Vault (Story 1B)
  #----------------------------------------------------------------------------
  # Note: Azure encrypts all data with Platform-Managed Keys (PMK) by default.
  # CMK provides additional control using your own keys in Key Vault.
  #
  # CMK encryption requires:
  # 1. Key Vault with a key created
  # 2. Storage account identity with access to Key Vault
  # 3. enable_cmk_encryption = true and key_vault_key_id provided
  #
  # If enable_cmk_encryption = false, Azure uses Platform-Managed Keys (default)
  #----------------------------------------------------------------------------
  dynamic "identity" {
    for_each = var.enable_cmk_encryption ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.enable_cmk_encryption ? [1] : []
    content {
      key_vault_key_id          = var.key_vault_key_id
      user_assigned_identity_id = var.user_assigned_identity_id
    }
  }

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

#------------------------------------------------------------------------------
# RBAC Role Assignments (Azure equivalent of IAM bucket policies)
#------------------------------------------------------------------------------
# Note: RBAC is not auto-assigned by this module. Teams should manage access
# separately using azurerm_role_assignment resource.
#
# Example usage (outside this module):
# resource "azurerm_role_assignment" "storage_blob_contributor" {
#   scope                = module.storage_account.storage_account_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = "user-or-service-principal-id"
# }
#
# Common Azure Storage RBAC roles:
# - Storage Blob Data Owner: Full access to blob data
# - Storage Blob Data Contributor: Read/write/delete blobs
# - Storage Blob Data Reader: Read-only access to blobs
# - Storage Account Contributor: Manage storage account (not data)
#------------------------------------------------------------------------------
