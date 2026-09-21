# Authenticates with Azure using the Azure CLI (`az login`).
# Run `az account show` to confirm the correct subscription is selected
# before `terraform plan` / `terraform apply`.

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
