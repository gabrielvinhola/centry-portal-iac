locals {
  name_suffix = "${var.landing_zone}-${var.environment}"

  tags = {
    "Environment" : var.environment
  }

  secrets = {}

  access_policies = {
    policy = {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      key_permissions         = ["Get", "Create", "Delete", "Import", "List", "Purge", "Recover", "GetRotationPolicy", "SetRotationPolicy", "UnwrapKey", "WrapKey"]
      secret_permissions      = ["Get", "Set", "Delete", "List", "Purge", "Recover"]
      certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Purge"]
    }
  }

  resource_ids = {
    kv            = module.keyvaults["kv-app-dev"].azure_key_vault_id
    storage_accnt = module.storage_account.storage_account_id
    acr           = azurerm_container_registry.this.id
    front_svc     = module.frontend.app_service.id
    back_svc      = module.backend.app_service.id
  }

  auth_settings = {
    enabled                       = false
    token_refresh_extension_hours = 0
  }

}
