locals {
  workspace_suffix = split("-", terraform.workspace)[length(split("-", terraform.workspace)) - 1]

  # Define distinct IP address ranges per workspace to avoid overlap
  vnet_cidrs = {
    dev     = "10.2.0.0/16"
    staging = "10.1.0.0/16"
    prod    = "10.0.0.0/16"
  }

  subnet_frontend_cidrs = {
    dev     = "10.2.1.0/24"
    staging = "10.1.1.0/24"
    prod    = "10.0.1.0/24"
  }

  subnet_backend_cidrs = {
    dev     = "10.2.2.0/24"
    staging = "10.1.2.0/24"
    prod    = "10.0.2.0/24"
  }

  subnet_db_cidrs = {
    dev     = "10.2.3.0/24"
    staging = "10.1.3.0/24"
    prod    = "10.0.3.0/24"
  }
}
