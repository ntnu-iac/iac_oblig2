# =============================================================================
#  removed.tf  –  app slipper VM-en og web app-en
# -----------------------------------------------------------------------------
#  destroy = false: oppføringene fjernes fra denne staten, ressursene blir
#  stående i Azure. service tar dem inn med import, én instans per tjeneste.
#  app står foran service i LAG i scripts/kjor.sh.
#
#  Alle ressursene i modulene følger med: offentlig IP, NIC og VM, og
#  App Service-plan og web app.
#
#  Stacken er tom etter dette, og slettes når dev og prod har fått det.
# =============================================================================

removed {
  from = module.vm

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.webapp

  lifecycle {
    destroy = false
  }
}
