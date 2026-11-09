# =============================================================================
#  import.tf  –  ressursgruppa og VNet-et flyttes hit fra network-stacken
# -----------------------------------------------------------------------------
#  network-stacken slipper dem med removed { destroy = false }. Den står foran
#  shared-network i LAG i scripts/kjor.sh, så i hver kjøring slippes de der
#  før de tas inn her.
#
#  ID-ene bygges fra abonnementet Terraform kjører mot. Ingen ID skrives av.
#  FJERNES når både dev og prod har fått flyttingen.
# =============================================================================

data "azurerm_subscription" "current" {}

import {
  to = azurerm_resource_group.this
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.rg_name}"
}

import {
  to = module.vnet.azurerm_virtual_network.this
  id = "${data.azurerm_subscription.current.id}/resourceGroups/${local.rg_name}/providers/Microsoft.Network/virtualNetworks/${local.vnet_name}"
}
