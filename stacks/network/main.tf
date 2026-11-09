# Nettverkslaget for ALLE tjenestene: ett subnett med NSG per tjeneste.
# Ressursgruppa og VNet-et er flyttet til shared-network (se removed.tf).
# Navnene bygges på samme måte som der, så subnettene peker på det samme.

locals {
  rg_name   = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name = "vnet-${var.kortnavn}-${var.miljo}"

  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }
}

module "subnet" {
  source   = "../../modules/subnet"
  for_each = var.tjenester

  service             = each.key
  resource_group_name = local.rg_name
  location            = var.location
  vnet_name           = local.vnet_name
  prefix              = each.value.prefix
  delegate_web        = each.value.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
}
