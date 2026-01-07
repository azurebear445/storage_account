output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "The full Azure resource ID of the storage account."
}

output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "The name of the storage account."
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.this.primary_blob_endpoint
  description = "The primary blob service endpoint URL."
}

output "primary_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "container_id" {
  value       = azurerm_storage_container.this.id
  description = "The full Azure resource ID of the blob container."
}

output "container_name" {
  value       = azurerm_storage_container.this.name
  description = "The name of the blob container."
}

output "subscription_id" {
  value       = data.azurerm_client_config.current.subscription_id
  description = "The Azure subscription ID."
}

output "tenant_id" {
  value       = data.azurerm_client_config.current.tenant_id
  description = "The Azure AD tenant ID."
}

output "location" {
  value       = azurerm_storage_account.this.location
  description = "The Azure region."
}

output "resource_group_name" {
  value       = azurerm_storage_account.this.resource_group_name
  description = "The resource group name."

  # If using existing resource group (Option 1), change to:
  # value = data.azurerm_resource_group.main.name
}

output "namespace" {
  value       = local.namespace
  description = "The computed namespace."
}

output "blob_url_prefix" {
  value       = "${azurerm_storage_account.this.primary_blob_endpoint}${azurerm_storage_container.this.name}/"
  description = "The full URL prefix for blobs in this container."
}
