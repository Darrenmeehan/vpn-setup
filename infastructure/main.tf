module "networking" {
  source = "./modules/networking"
}

module "server" {
  source    = "./modules/server"
  subnet_id = module.networking.subnet_id
}
