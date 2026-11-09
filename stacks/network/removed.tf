# =============================================================================
#  removed.tf  –  ressursgruppa og VNet-et slippes til shared-network
# -----------------------------------------------------------------------------
#  destroy = false: oppføringen fjernes fra denne staten, ressursen blir stående
#  i Azure. shared-network tar dem inn med import i samme kjøring, fordi
#  network står foran shared-network i LAG i scripts/kjor.sh.
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
