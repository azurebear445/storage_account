# Create Resource Group for testing
resource "azurerm_resource_group" "this" {
  name     = "rg-storage-example"
  location = "centralus"
}

module "storage_account" {
  # source = "../../"
  source = "git::ssh://git@gitlab.com/webster-bank/team-cloud-engineering/system-azure_terraform_modules/terraform-azurerm-storage_account.git?ref=CLOUD-XXXX"

  namespace           = var.namespace
  environment         = var.environment
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
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
