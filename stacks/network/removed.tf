# =============================================================================
#  removed.tf  –  network slipper alt det eide
# -----------------------------------------------------------------------------
#  destroy = false: oppføringene fjernes fra denne staten, ressursene blir
#  stående i Azure. Ressursgruppa og VNet-et er tatt inn av shared-network,
#  subnettene med NSG, regel og kobling tas inn av service (én per tjeneste).
#  network står foran begge i LAG i scripts/kjor.sh.
#
#  Stacken er tom etter dette, og slettes når dev og prod har fått det.
# =============================================================================

removed {
  from = azurerm_resource_group.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.vnet

  lifecycle {
    destroy = false
  }
}

# Hele modulen, alle tjenestene: subnett, NSG, NSG-regel og NSG-kobling.
removed {
  from = module.subnet

  lifecycle {
    destroy = false
  }
}
