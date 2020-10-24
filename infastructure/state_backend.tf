#
# Handles Terraform's State Backend
#

terraform {
  backend "remote" {
    organization = "home-network"

    workspaces {
      name = "vpn-setup"
    }
  }
}
