resource "azurerm_linux_web_app" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.rg_name
  service_plan_id               = var.asp_id
  https_only                    = var.https_only
  client_affinity_enabled       = var.client_affinity_enabled
  client_certificate_enabled    = var.client_cert_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  app_settings                  = merge(var.app_service_settings)
  tags                          = var.tags
  public_network_access_enabled = var.public_network_access_enabled
  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  site_config {
    ftps_state                              = "Disabled"
    always_on                               = true
    http2_enabled                           = var.http2_enabled
    remote_debugging_enabled                = false
    minimum_tls_version                     = "1.2"
    websockets_enabled                      = false
    vnet_route_all_enabled                  = lookup(var.settings.site_config, "vnet_route_all_enabled", true)
    health_check_path                       = var.health_check_path
    health_check_eviction_time_in_min       = var.health_check_eviction_time_in_min
    container_registry_use_managed_identity = var.container_registry_use_managed_identity
    // Not supported in current azurerm version
    dynamic "ip_restriction" {
      for_each = lookup(var.settings.site_config, "ip_restriction", {})
      content {
        action      = lookup(ip_restriction.value, "action", null)
        ip_address  = lookup(ip_restriction.value, "ip_address", null)
        priority    = lookup(ip_restriction.value, "priority", null)
        name        = lookup(ip_restriction.value, "name", null)
        service_tag = lookup(ip_restriction.value, "service_tag", null)
      }
    }
    dynamic "application_stack" {
      for_each = lookup(var.settings.site_config, "application_stack", {}) != {} ? [1] : []
      content {
        java_version             = lookup(var.settings.site_config.application_stack, "java_version", null)
        java_server              = lookup(var.settings.site_config.application_stack, "java_server", null)
        java_server_version      = lookup(var.settings.site_config.application_stack, "java_server_version", null)
        php_version              = lookup(var.settings.site_config.application_stack, "php_version", null)
        ruby_version             = lookup(var.settings.site_config.application_stack, "ruby_version", null)
        dotnet_version           = lookup(var.settings.site_config.application_stack, "dotnet_version", null)
        node_version             = lookup(var.settings.site_config.application_stack, "node_version", null)
        python_version           = lookup(var.settings.site_config.application_stack, "python_version", null)
        docker_image_name        = lookup(var.settings.site_config.application_stack, "docker_image_name", null)
        docker_registry_url      = lookup(var.settings.site_config.application_stack, "docker_registry_url", null)
        docker_registry_username = lookup(var.settings.site_config.application_stack, "docker_registry_username", null)
        docker_registry_password = lookup(var.settings.site_config.application_stack, "docker_registry_password", null)
      }
    }

    cors {
      allowed_origins     = var.allowed_origins
      support_credentials = var.support_credentials
    }
  }

  dynamic "auth_settings" {
    for_each = var.auth_settings != {} ? [1] : []

    content {
      enabled                       = lookup(var.auth_settings, "enabled", false)
      issuer                        = lookup(var.auth_settings, "issuer", null)
      token_refresh_extension_hours = lookup(var.auth_settings, "token_refresh_extension_hours", 0)
      dynamic "active_directory" {
        for_each = lookup(var.auth_settings, "active_directory", null) != null ? [1] : []

        content {
          client_id                  = lookup(var.auth_settings.active_directory, "client_id", "")
          client_secret              = lookup(var.auth_settings.active_directory, "client_secret", "")
          allowed_audiences          = lookup(var.auth_settings.active_directory, "allowed_audiences", null)
          client_secret_setting_name = lookup(var.auth_settings.active_directory, "client_secret_setting_name", "")
        }
      }
    }
  }

  logs {

    failed_request_tracing  = var.failed_request_tracing
    detailed_error_messages = var.detailed_error_messages
    application_logs {
      file_system_level = "Warning"
    }

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 100
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = "diag-rule-${var.env}-${var.location}-001"
  target_resource_id             = azurerm_linux_web_app.this.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  dynamic "enabled_log" {
    iterator = entry
    for_each = var.app_service_diagnostics.logs
    content {
      category = entry.value
    }

  }

  dynamic "metric" {
    for_each = var.app_service_diagnostics.metrics
    content {
      category = metric.value
    }
  }
  lifecycle {
    ignore_changes = [
      # https://github.com/hashicorp/terraform-provider-azurerm/issues/20140
      log_analytics_destination_type
    ]
  }
}
