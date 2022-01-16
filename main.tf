resource "azurerm_storage_account" "storage_account" {
  name                     = var.sa_name
  resource_group_name      = var.sa_rg_name
  location                 = var.sa_location
  account_tier             = var.sa_acc_tier
  account_replication_type = var.sa_acc_repl_type

  tags = {
    environment =  var.sa_env
  }
}