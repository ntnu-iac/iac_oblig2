# =============================================================================
#  removed.tf  –  data slipper storage account-ene og Key Vault-ene
# -----------------------------------------------------------------------------
#  destroy = false: oppføringene fjernes fra denne staten, ressursene blir
#  stående i Azure. service tar dem inn med import, én instans per tjeneste.
#  data står foran service i LAG i scripts/kjor.sh.
#
#  Stacken er tom etter dette, og slettes når dev og prod har fått det.
# =============================================================================

removed {
  from = module.storage

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.keyvault

  lifecycle {
    destroy = false
  }
}
