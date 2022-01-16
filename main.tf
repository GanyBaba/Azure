terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resourcegroup" {
  source   = "./modules/resourcegroup"
  name     = var.name
  location = var.location
}

module "networking" {
  source         = "./modules/networking"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  appsubnetcidr  = var.appsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
}

module "storage" {
  source           = "./modules/storage"
  sa_rg_name   = module.resourcegroup.resource_group_name
  sa_location         = module.resourcegroup.location_id
  sa_name          = var.sa_name
  sa_acc_tier      = var.sa_acc_tier
  sa_acc_repl_type = var.sa_acc_repl_type
  sa_env           = var.sa_env
}