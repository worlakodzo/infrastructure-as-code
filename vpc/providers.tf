provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project    = "SOW PACKAGE"
      Manager    = "Develeap"
      created_by = "Develeap Sow Package Team"
      workspace  = terraform.workspace
    }
  }
}
