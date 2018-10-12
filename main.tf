resource "null_resource" "test" {
  count = "${var.myvar}"
}

variable "myvar" {}
