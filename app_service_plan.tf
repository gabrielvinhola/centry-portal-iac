module "app_service_plan" {
  source                 = "./modules/app_service_plan"
  name                   = var.app_service_plan.name
  resource_group_name    = module.resourcegroups[var.app_service_plan.rg_key].rg_name
  location               = module.resourcegroups[var.app_service_plan.rg_key].rg_location
  os_type                = "Linux"
  sku_name               = "P2v3"
  tags                   = local.tags
  worker_count           = var.worker_count
  zone_balancing_enabled = var.zone_balancing_enabled
}
