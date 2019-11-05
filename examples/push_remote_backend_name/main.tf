terraform {
  backend "remote" {
    workspaces {
      name = "github-actions"
    }
  }
}

resource "null_resource" "root" {
  triggers = {
    value = "${timestamp()}"
  }
}
