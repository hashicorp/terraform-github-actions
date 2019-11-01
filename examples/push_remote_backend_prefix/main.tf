terraform {
  backend "remote" {
    workspaces {
      prefix = "github-actions-"
    }
  }
}

resource "null_resource" "root" {
  triggers = {
    value = "${timestamp()}"
  }
}
