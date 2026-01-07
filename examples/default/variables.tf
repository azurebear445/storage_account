variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "namespace" {
  type    = string
  default = "test-storage"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "resource_group_name" {
  type    = string
  default = "rg-sandbox-storage-test"
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "tags" {
  type = map(string)
  default = {
    architecture       = "migrations"
    owner              = "cloud-engineering"
    purpose            = "Sandbox-testing-for-Azure-storage-account-Terraform-module."
    terraform_resource = "true"
    project            = "azure-storage-migration"
  }
}
