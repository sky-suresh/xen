terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
 features {
   
 }

  subscription_id = "252026ba-6735-4965-9bbf-6bad9c701532"
}
