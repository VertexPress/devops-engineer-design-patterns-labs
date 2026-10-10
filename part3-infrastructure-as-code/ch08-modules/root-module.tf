module "network" {
  source             = "./modules/network"
  name               = "quote-prod"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
module "database" {
  source     = "./modules/database"
  name       = "quote-prod"
  subnet_ids = module.network.subnet_ids
  vpc_id     = module.network.vpc_id
}
