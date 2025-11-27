terraform {
  backend "remote" {
    organization = "dvtestorg"

    workspaces {
      prefix = "govtech-"
    }
  }
}
