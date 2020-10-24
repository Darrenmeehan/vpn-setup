#
# Handles Terraform's State Backend
#

terraform {
  backend "remote" {
    organization = "drn"

    workspaces {
      name = "dev"
    }
  }
}
