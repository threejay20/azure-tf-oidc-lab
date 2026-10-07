terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    container_name   = "tfstate"
    key              = "lab/terraform.tfstate"
    use_azuread_auth = true
    use_oidc         = true
  }
}

provider "azurerm" {
  features {}

  use_oidc                        = true
  resource_provider_registrations = "none"
}
