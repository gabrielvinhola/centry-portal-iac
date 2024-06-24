module "postgres_flexible" {
  source                          = "./modules/postgres_flexible"
  postgresql_flexible_server_name = var.postgresql_flexible_server_name
  location                        = module.resourcegroups["default-uks"].rg_location
  resource_group_name             = module.resourcegroups["default-uks"].rg_name
  tier                            = var.postgres_sku_name
  size                            = var.size
  storage_mb                      = var.postgres_storage_mb
  zone                            = var.postgres_zone
  administrator_login             = var.administrator_login
  administrator_password          = random_password.pgresqlrisk_administrator_login_password.result
  postgresql_flexible_databases   = var.postgresql_flexible_databases
  tags                            = local.tags
  backup_retention_days           = var.backup_retention_days
  geo_redundant_backup_enabled    = var.geo_redundant_backup_enabled
  virtual_network_id              = module.network["vnet-uks"].vnet_id
  delegated_subnet_id             = lookup(module.network["vnet-uks"].subnet_id_list, "postgres")
  dnszone_name_prefix             = "${local.dns_posgtres}.${var.location}"
  postgresql_privatednszone_id    = null
}

resource "random_password" "pgresqlrisk_administrator_login_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
