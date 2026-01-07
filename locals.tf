locals {
  # Combines namespace and environment for resource naming
  namespace = "${var.namespace}-${var.environment}"

  # Storage Account Name - Azure constraints: 3-24 chars, lowercase alphanumeric only
  storage_account_name_base      = replace(local.namespace, "-", "")
  storage_account_name_truncated = substr(local.storage_account_name_base, 0, min(24, length(local.storage_account_name_base)))
  storage_account_name = (
    var.custom_storage_account_name != "" ?
    var.custom_storage_account_name :
    local.storage_account_name_truncated
  )

  # Container Name - Azure constraints: 3-63 chars, lowercase alphanumeric and hyphens
  container_name_base      = "${local.namespace}-container"
  container_name_truncated = substr(local.container_name_base, 0, min(63, length(local.container_name_base)))
  container_name = (
    var.custom_container_name != "" ?
    var.custom_container_name :
    local.container_name_truncated
  )

  # Merge tags with environment
  tags = merge(var.tags, { environment = var.environment })

  # Azure compliance tags (similar to AWS Cloud Custodian tags)
  azure_compliance_tags = {
    "azure:storage_account_tier"     = var.account_tier
    "azure:storage_replication_type" = var.account_replication_type
    "azure:container_access_type"    = var.container_access_type
  }

  # Final resource tags
  storage_account_tags = merge(
    local.tags,
    local.azure_compliance_tags,
    { Name = local.storage_account_name }
  )
}
