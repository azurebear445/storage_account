module "storage_account" {
  source = "../../"

  namespace           = var.namespace
  environment         = var.environment
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

output "storage_account_id" {
  value = module.storage_account.storage_account_id
}

output "storage_account_name" {
  value = module.storage_account.storage_account_name
}

output "container_name" {
  value = module.storage_account.container_name
}

output "primary_blob_endpoint" {
  value = module.storage_account.primary_blob_endpoint
}
