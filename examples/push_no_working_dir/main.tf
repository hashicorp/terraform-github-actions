resource "null_resource" "root" {
  triggers = {
    value = "${timestamp()}"
  }
}
