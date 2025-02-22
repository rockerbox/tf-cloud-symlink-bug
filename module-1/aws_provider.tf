provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "Component"    = "tfc-symlink-bug/module-1"
      "Environment"  = "Development"
      "Owner"        = "dlidralporter"
      "Team"         = "Infrastructure"
      "VantaNonProd" = "true"
    }
  }
}
