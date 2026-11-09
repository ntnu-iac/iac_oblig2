tjeneste = "ordre"
runtime  = "vm"
prefix   = "10.10.0.0/24"

# En offentlig nøkkel uten tilhørende privat nøkkel: ingen kan logge inn på
# VM-en. Den PRIVATE nøkkelen skal aldri i repoet.
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMQ32gu8mGVI86gkUex5JsBeg7WC58bsUOVuxmeHDJW oblig2-ingen-privat-nokkel"

# EO 1: ordre skal godta TCP 8837 fra 172.16.220.0/24.
ekstra_regler = {
  allow-tcp-8837 = { priority = 110, port = 8837, source = "172.16.220.0/24" }
}
