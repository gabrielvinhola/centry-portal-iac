module "storage_account" {
  source                            = "./modules/storage_account"
  storage_account_name              = var.storage_profile.name
  resource_group_name               = module.resourcegroups[var.storage_profile.rg_key].rg_name
  location                          = module.resourcegroups[var.storage_profile.rg_key].rg_location
  account_kind                      = var.storage_profile.account_kind
  account_tier                      = var.storage_profile.account_tier
  account_replication_type          = var.storage_profile.account_replication_type
  min_tls_version                   = var.storage_profile.min_tls_version
  shared_access_key_enabled         = var.storage_profile.shared_access_key_enabled
  containers_list                   = var.storage_profile.containers_list
  blob_soft_delete_retention_days   = var.storage_profile.blob_soft_delete_retention_days
  container_delete_retention_days   = var.storage_profile.container_delete_retention_days
  enable_versioning                 = var.storage_profile.enable_versioning
  infrastructure_encryption_enabled = var.storage_profile.infrastructure_encryption_enabled
  change_feed_enabled               = var.storage_profile.change_feed_enabled
  blob_restore_days                 = var.storage_profile.blob_restore_days
  public_network_access_enabled     = true
  network_rules = {
    "ip_rules"                   = []
    "virtual_network_subnet_ids" = []
    "bypass"                     = ["AzureServices"]
  }
  tags = local.tags
}
