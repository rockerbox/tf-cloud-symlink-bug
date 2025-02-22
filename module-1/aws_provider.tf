provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "Component"    = "tfc-symlink-bug/module-1"
      "Environment"  = var.environment
      "Owner"        = "dlidralporter"
      "Team"         = "Infrastructure"
      "VantaNonProd" = var.environment == "Production" ? "false" : "true"
    }
  }
}
