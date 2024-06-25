module "grafana" {
  source                     = "./modules/grafana"
  instance_name              = "app-dev-grafana-uks-001"
  resource_group_name        = module.resourcegroups["default-uks"].rg_name
  location                   = module.resourcegroups["default-uks"].rg_location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_workspace.id
}

# Give Managed Grafana instances access to read monitoring data in given resource group.
resource "azurerm_role_assignment" "monitoring_reader" {
  scope                = module.resourcegroups["default-uks"].rg_id
  role_definition_name = "Monitoring Reader"
  principal_id         = module.grafana.identity_principal_id
}

# Give current client admin access to Managed Grafana instance.
resource "azurerm_role_assignment" "grafana_admin" {
  scope                = module.grafana.instance_id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}