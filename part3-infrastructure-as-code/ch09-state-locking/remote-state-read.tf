data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "vertexpress-tfstate"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}
resource "aws_db_subnet_group" "this" {
  name       = "quote-prod"
  subnet_ids = data.terraform_remote_state.network.outputs.subnet_ids
}
