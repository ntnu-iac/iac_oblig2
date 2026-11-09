# =============================================================================
#  import.tf  –  tjenestens ressurser flyttes hit fra network, data og app
# -----------------------------------------------------------------------------
#  De gamle stackene slipper dem med removed { destroy = false }. De står foran
#  service i LAG i scripts/kjor.sh, så i hver kjøring slippes de der før de tas
#  inn her.
#
#  ID-ene bygges fra ressursgruppa sin ID i shared-network og navnene modulene
#  lager. Ingen ID skrives av, og ingen abonnements-ID står i koden.
#  Blokkene for kjøremiljøet har for_each, så bare de som passer runtime, gjelder.
#
#  FJERNES når både dev og prod har fått flyttingen.
# =============================================================================

locals {
  rg_id     = local.net.resource_group_id
  nett      = "${local.rg_id}/providers/Microsoft.Network"
  subnet_id = "${local.nett}/virtualNetworks/${local.net.vnet_name}/subnets/snet-${var.tjeneste}"
  nsg_id    = "${local.nett}/networkSecurityGroups/nsg-${var.tjeneste}"
}

# --- nettverk (fra network) -------------------------------------------------

import {
  to = module.subnet.azurerm_subnet.this
  id = local.subnet_id
}

import {
  to = module.subnet.azurerm_network_security_group.this
  id = local.nsg_id
}

import {
  to = module.subnet.azurerm_network_security_rule.http
  id = "${local.nsg_id}/securityRules/allow-http"
}

# Koblingen er en egen ressurs, og ID-en dens er subnettets ID.
import {
  to = module.subnet.azurerm_subnet_network_security_group_association.this
  id = local.subnet_id
}

# --- data (fra data) ---------------------------------------------------------

import {
  to = module.storage.azurerm_storage_account.this
  id = "${local.rg_id}/providers/Microsoft.Storage/storageAccounts/st${var.kortnavn}${var.tjeneste}${var.miljo}"
}

import {
  to = module.keyvault.azurerm_key_vault.this
  id = "${local.rg_id}/providers/Microsoft.KeyVault/vaults/kv-${var.kortnavn}-${var.tjeneste}-${var.miljo}"
}

# --- kjøremiljø (fra app) ------------------------------------------------------

import {
  for_each = local.vm
  to       = module.vm[each.key].azurerm_public_ip.this
  id       = "${local.nett}/publicIPAddresses/pip-${var.tjeneste}"
}

import {
  for_each = local.vm
  to       = module.vm[each.key].azurerm_network_interface.this
  id       = "${local.nett}/networkInterfaces/nic-${var.tjeneste}"
}

import {
  for_each = local.vm
  to       = module.vm[each.key].azurerm_linux_virtual_machine.this
  id       = "${local.rg_id}/providers/Microsoft.Compute/virtualMachines/vm-${var.tjeneste}"
}

import {
  for_each = local.webapp
  to       = module.webapp[each.key].azurerm_service_plan.this
  id       = "${local.rg_id}/providers/Microsoft.Web/serverFarms/asp-${var.tjeneste}"
}

import {
  for_each = local.webapp
  to       = module.webapp[each.key].azurerm_linux_web_app.this
  id       = "${local.rg_id}/providers/Microsoft.Web/sites/app-${var.kortnavn}-${var.tjeneste}-${var.miljo}"
}
