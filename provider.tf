terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
 features {}

  subscription_id = "252026ba-6735-4965-9bbf-6bad9c701532"
  tenant_id = "ddba09d2-5005-40ad-b8b5-6f7967a19bcf"
}
