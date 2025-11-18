terraform {
  backend "remote" {
    organization = "dvtestorg"

    workspaces {
      name = "azure-dev-env"
    }
  }
}

resource "null_resource" "example" {
  triggers = {
    value = "A example resource that does nothing!"
  }
}
