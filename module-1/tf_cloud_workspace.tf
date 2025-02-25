terraform {
  backend "remote" {
    organization = "rockerbox"

    workspaces {
      name = "symlink-bug-demo-development"
    }
  }
}
