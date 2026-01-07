#------------------------------------------------------------------------------
# Required Variables
#------------------------------------------------------------------------------

variable "namespace" {
  type        = string
  description = "Namespace for resources created by this Terraform configuration. Used to group related resources. Must contain only lowercase letters and dashes, and be under 32 characters."

  validation {
    condition = (
      length(var.namespace) < 32 &&
      can(regex("^[a-z][-a-z]+$", var.namespace))
    )
    error_message = "The namespace variable must contain only lowercase letters and dashes, and be under 32 characters."
  }
}

variable "environment" {
  type        = string
  description = "The environment where the resources created by this Terraform configuration will be deployed. Value must be one of: box, dev, dr, prod, qa, stage, or uat."

  validation {
    condition = (
      var.environment == "box" ||
      var.environment == "dev" ||
      var.environment == "dr" ||
      var.environment == "prod" ||
      var.environment == "qa" ||
      var.environment == "stage" ||
      var.environment == "uat"
    )
    error_message = "The environment variable must be one of: box, dev, dr, prod, qa, stage, or uat."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where the storage account will be created. Must already exist."
}

variable "location" {
  type        = string
  description = "The Azure region where the storage account will be created. Example: eastus2, centralus."
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to module resources. Must include architecture, owner, purpose, terraform_resource, and one of appid/appgsid/project/serviceid."

  validation {
    condition = (
      contains(keys(var.tags), "architecture") &&
      contains(keys(var.tags), "owner") &&
      contains(keys(var.tags), "purpose") &&
      contains(keys(var.tags), "terraform_resource") && (
        contains(keys(var.tags), "appid") ||
        contains(keys(var.tags), "appgsid") ||
        contains(keys(var.tags), "project") ||
        contains(keys(var.tags), "serviceid")
      ) && alltrue([
        for k, v in var.tags : can(regex("^[-0-9_A-Za-z]+$", v)) if k != "purpose"
      ])
    )
    error_message = "The keys in the tags map must include: architecture, owner, purpose, terraform_resource, and one of appid|appgsid|project|serviceid."
  }

  validation {
    condition = (
      var.tags["architecture"] == "native" ||
      var.tags["architecture"] == "legacy" ||
      var.tags["architecture"] == "migrations"
    )
    error_message = "The architecture tag must have a value of \"native\"|\"legacy\"|\"migrations\"."
  }

  validation {
    condition = (
      length(var.tags["purpose"]) > 40 &&
      can(regex("^[A-Z][,-.A-Za-z]+[.]$", var.tags["purpose"]))
    )
    error_message = "The purpose tag must begin with a capital letter, be over 40 characters, and end with a period \".\". It can contain only capital, lowercase letters, period, comma, and hyphen."
  }

  validation {
    condition = (
      var.tags["terraform_resource"] == "true"
    )
    error_message = "The terraform_resource tag must have a value of \"true\"."
  }
}

#------------------------------------------------------------------------------
# Optional Variables - Naming
#------------------------------------------------------------------------------

variable "custom_storage_account_name" {
  type        = string
  default     = ""
  description = "Use this variable to set your own custom storage account name. If empty, the module will auto-generate a name from namespace and environment. Must be 3-24 characters, lowercase alphanumeric only."

  validation {
    condition = (
      var.custom_storage_account_name == "" ||
      (
        length(var.custom_storage_account_name) >= 3 &&
        length(var.custom_storage_account_name) <= 24 &&
        can(regex("^[a-z0-9]+$", var.custom_storage_account_name))
      )
    )
    error_message = "Custom storage account name must be 3-24 characters, lowercase alphanumeric only (no hyphens, underscores, or special characters)."
  }
}

variable "custom_container_name" {
  type        = string
  default     = ""
  description = "Use this variable to set your own custom container name. If empty, the module will auto-generate a name from namespace and environment. Must be 3-63 characters, lowercase alphanumeric and hyphens only."

  validation {
    condition = (
      var.custom_container_name == "" ||
      (
        length(var.custom_container_name) >= 3 &&
        length(var.custom_container_name) <= 63 &&
        can(regex("^[a-z0-9][-a-z0-9]*[a-z0-9]$", var.custom_container_name))
      )
    )
    error_message = "Custom container name must be 3-63 characters, lowercase alphanumeric and hyphens only, cannot start or end with a hyphen."
  }
}

#------------------------------------------------------------------------------
# Optional Variables - Storage Account Configuration
#------------------------------------------------------------------------------

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Defines the performance tier of the storage account. Standard uses HDD-backed storage, Premium uses SSD-backed storage."

  validation {
    condition     = var.account_tier == "Standard" || var.account_tier == "Premium"
    error_message = "Account tier must be either 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  type        = string
  default     = "GRS"
  description = "Defines the replication strategy for the storage account. Options: LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS."

  validation {
    condition = contains(
      ["LRS", "ZRS", "GRS", "RAGRS", "GZRS", "RAGZRS"],
      var.account_replication_type
    )
    error_message = "Account replication type must be one of: LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS."
  }
}

variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Defines the kind of storage account. StorageV2 is recommended for most scenarios."

  validation {
    condition = contains(
      ["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"],
      var.account_kind
    )
    error_message = "Account kind must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "access_tier" {
  type        = string
  default     = "Hot"
  description = "Defines the default access tier for blob storage. Hot for frequently accessed data, Cool for infrequently accessed data."

  validation {
    condition     = var.access_tier == "Hot" || var.access_tier == "Cool"
    error_message = "Access tier must be either 'Hot' or 'Cool'."
  }
}

variable "container_access_type" {
  type        = string
  default     = "private"
  description = "Specifies the access level for the container. private = no anonymous access, blob = anonymous read for blobs only, container = anonymous read for container and blobs."

  validation {
    condition     = contains(["private", "blob", "container"], var.container_access_type)
    error_message = "Container access type must be one of: private, blob, container."
  }
}
