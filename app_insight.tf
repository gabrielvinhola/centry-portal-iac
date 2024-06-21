module "app_insights" {
  source              = "./modules/app_insights"
  workspace_id        = resource.azurerm_log_analytics_workspace.la_workspace.id
  name                = var.app_insights.name
  resource_group_name = module.resourcegroups[var.app_insights.rg_key].rg_name
  location            = module.resourcegroups[var.app_insights.rg_key].rg_location
  tags                = local.tags
}
