# Azure Storage Account Module

Terraform module which creates an Azure Storage Account with a blob container.

## Usage

```hcl
module "storage_account" {
  source = "git::https://your-gitlab/terraform-azurerm-storage_account.git"

  namespace           = "payment-service"
  environment         = "prod"
  resource_group_name = "rg-prod-storage"
  location            = "eastus2"

  tags = {
    architecture       = "native"
    owner              = "team-payments"
    purpose            = "Customer payment data storage for the payments microservice."
    terraform_resource = "true"
    appid              = "APP-12345"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 4.0 |

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| namespace | string | - | yes | Namespace for resources. Lowercase letters and dashes, under 32 characters. |
| environment | string | - | yes | Environment: box, dev, dr, prod, qa, stage, or uat. |
| resource_group_name | string | - | yes | Name of an existing Azure Resource Group. |
| location | string | - | yes | Azure region (e.g., eastus2, centralus). |
| tags | map(string) | - | yes | Required tags. |
| custom_storage_account_name | string | "" | no | Custom storage account name (3-24 chars, lowercase alphanumeric). |
| custom_container_name | string | "" | no | Custom container name (3-63 chars). |
| account_tier | string | "Standard" | no | Performance tier: Standard or Premium. |
| account_replication_type | string | "GRS" | no | Replication: LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS. |
| account_kind | string | "StorageV2" | no | Account kind. |
| access_tier | string | "Hot" | no | Default blob tier: Hot or Cool. |
| container_access_type | string | "private" | no | Container access: private, blob, or container. |

## Outputs

| Name | Description |
|------|-------------|
| storage_account_id | Storage account resource ID. |
| storage_account_name | Storage account name. |
| container_id | Blob container resource ID. |
| container_name | Blob container name. |
| primary_blob_endpoint | Blob service endpoint URL. |
| primary_access_key | Primary access key (sensitive). |
| subscription_id | Azure subscription ID. |
| tenant_id | Azure AD tenant ID. |
| location | Azure region. |
| resource_group_name | Resource group name. |
| namespace | Computed namespace. |
| blob_url_prefix | Full URL prefix for blobs. |

## Examples

See the [examples/](./examples/) directory.
