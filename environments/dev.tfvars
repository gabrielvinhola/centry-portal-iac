environment  = "dev"
landing_zone = "app"
location     = "uksouth"

#region Resource Groups
resource_groups = {
  default-uks = {
    prefix   = "rg"
    location = "uksouth"
  }
  network-uks = {
    prefix   = "rg-network"
    location = "uksouth"
  }
}

#region Virtual Networks
vnet_profile = {
  vnet-uks = {
    name             = "vnet-app-dev-uks-001"
    address_space    = ["10.68.26.0/24"]
    route_table_name = "udr-app-dev-uks-001"
    rg_key           = "network-uks"
    routes           = {}
    subnets = {
      frontend = {
        name                                          = "snet-frontend-app-dev-uks-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = false
        address_prefixes                              = ["10.68.26.0/27"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
          }
        }
        nsg_name  = "nsg-frontend-app-dev-uks-001"
        nsg_rules = []
      },
      backend = {
        name                                          = "snet-backend-app-dev-uks-001"
        private_link_service_network_policies_enabled = false
        private_endpoint_network_policies_enabled     = false
        address_prefixes                              = ["10.68.26.96/28"]
        delegation = {
          name = "delegation"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
          }
        }
        nsg_name  = "nsg-backend-app-dev-uks-001"
        nsg_rules = []
      },
      pe = {
        name                                          = "snet-pe-dev-uks-001"
        private_link_service_network_policies_enabled = true
        private_endpoint_network_policies_enabled     = true
        address_prefixes                              = ["10.68.26.176/29"]
        nsg_name                                      = "nsg-pe-app-dev-uks-001"
        nsg_rules                                     = []
      },
    }
  }
}

keyvaults = {
  kv-app-dev = {
    name           = "kv-app-d-eu-001"
    sku_name       = "standard"
    bypass         = "AzureServices"
    default_action = "Deny"
    rg_key         = "default-uks"
    subnet_ids     = []
    subnet_ids     = []
    ip_rules       = []
  }
}

storage_profile = {
  name                              = "stappdevuksouth001"
  rg_key                            = "default-uks"
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "GRS"
  min_tls_version                   = "TLS1_2"
  shared_access_key_enabled         = false
  infrastructure_encryption_enabled = true
}

acr_name = "crappdevuksouth"

private_endpoint = {
  pe_eus_kv = {
    name                 = "pe-keyvault-app-dev-uksouth-001"
    rg_key               = "default-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "kv_dns"
    resource             = "kv"
    is_manual_connection = false
    subresource_names    = ["vault"]
    request_message      = ""
  }
  pe_eus_storage = {
    name                 = "pe-storageaccount-app-dev-uksouth-001"
    rg_key               = "default-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "storage_dns"
    resource             = "storage_accnt"
    is_manual_connection = false
    subresource_names    = ["Blob"]
    request_message      = ""
  }
  pe_eus_acr = {
    name                 = "pe-acr-app-dev-uksouth-001"
    rg_key               = "default-uks"
    vnet_key             = "vnet-uks"
    snet_key             = "pe"
    dns_key              = "acr_dns"
    resource             = "acr"
    is_manual_connection = false
    subresource_names    = ["registry"]
    request_message      = ""
  }
}

private_dns = {
  kv_dns = {
    name   = "privatelink.vaultcore.azure.net"
    rg_key = "network-uks"
  }
  storage_dns = {
    name   = "privatelink.blob.core.windows.net"
    rg_key = "network-uks"
  }
  acr_dns = {
    name   = "privatelink.azurecr.io"
    rg_key = "network-uks"
  }
}
