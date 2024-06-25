module "frontend" {
  source                                  = "./modules/app_service"
  name                                    = var.frontend.name
  rg_name                                 = module.resourcegroups[var.frontend.rg_key].rg_name
  location                                = module.resourcegroups[var.frontend.rg_key].rg_location
  asp_id                                  = module.app_service_plan.id
  log_analytics_workspace_id              = resource.azurerm_log_analytics_workspace.la_workspace.id
  env                                     = var.frontend.env
  auth_settings                           = local.auth_settings
  container_registry_use_managed_identity = true

  settings = {
    site_config = {
      application_stack = {
        docker_image_name = "hello-world"
        # docker_registry_url = "https://${var.acr_name}.azurecr.io"
      }
    }
  }

  virtual_network_subnet_id = lookup(module.network[var.frontend.vnet_key].subnet_id_list, var.frontend.snet_key)
  identity_type             = "SystemAssigned"
  require_assignment        = var.frontend.require_assignment
  scope                     = azurerm_container_registry.this.id

  role_assignments = {
    "acr" = {
      role = "AcrPush"
    }
  }

  allowed_origins = var.frontend.allowed_origins

  app_service_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.app_insights.connection_string
    APPINSIGHTS_INSTRUMENTATIONKEY        = module.app_insights.instrumentation_key
    ConnectionStrings__AdminDB            = "host=${module.postgres_flexible.postgresql_flexible_fqdn};Database=postgres;Port=5432;Username=${module.postgres_flexible.postgresql_administrator_login};Password=${random_password.pgresqlrisk_administrator_login_password.result};Trust Server Certificate=true"
  }

  log_analytics_destination_type = "AzureDiagnostics"
  tags                           = local.tags
  depends_on                     = [module.app_service_plan]
  public_network_access_enabled  = var.frontend.public_network_access_enabled
}

module "backend" {
  source                                  = "./modules/app_service"
  name                                    = var.backend.name
  rg_name                                 = module.resourcegroups[var.backend.rg_key].rg_name
  location                                = module.resourcegroups[var.backend.rg_key].rg_location
  asp_id                                  = module.app_service_plan.id
  log_analytics_workspace_id              = resource.azurerm_log_analytics_workspace.la_workspace.id
  env                                     = var.backend.env
  auth_settings                           = local.auth_settings
  container_registry_use_managed_identity = true

  settings = {
    site_config = {
      application_stack = {
        docker_image_name = "hello-world"
        # docker_registry_url = "https://${var.acr_name}.azurecr.io"
      }
    }
  }

  virtual_network_subnet_id = lookup(module.network[var.backend.vnet_key].subnet_id_list, var.backend.snet_key)
  identity_type             = "SystemAssigned"
  require_assignment        = var.backend.require_assignment
  scope                     = azurerm_container_registry.this.id

  role_assignments = {
    "acr" = {
      role = "AcrPush"
    }
  }

  allowed_origins = var.backend.allowed_origins

  app_service_settings = {}

  log_analytics_destination_type = "AzureDiagnostics"
  tags                           = local.tags
  depends_on                     = [module.app_service_plan]
  public_network_access_enabled  = var.backend.public_network_access_enabled
}
