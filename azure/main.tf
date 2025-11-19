terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "remote" {
    organization = "dvtestorg"

    workspaces {
      prefix = "govtech-"
    }
  }
}

provider "azurerm" {
  features {}
}
