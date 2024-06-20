module "keyvaults" {
  for_each                        = var.keyvaults
  source                          = "./modules/keyvault"
  name                            = each.value.name
  location                        = module.resourcegroups[each.value.rg_key].rg_location
  resource_group_name             = module.resourcegroups[each.value.rg_key].rg_name
  sku_name                        = each.value.sku_name
  tags                            = local.tags
  bypass_traffic                  = each.value.bypass
  default_action                  = each.value.default_action
  subnet_ids                      = each.value.subnet_ids
  public_network_access_enabled   = true
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  secrets                         = local.secrets
  key_vault_ip_rules              = concat(each.value.ip_rules, ["${data.http.this.response_body}/32"])
  access_policies                 = local.access_policies
  disk_encryption_sets            = each.value.disk_encryption_set
  keys_list                       = each.value.key_list
  #access_policies     = local.access_policies


}

resource "time_offset" "expiry_date" {
  offset_months = 3
}