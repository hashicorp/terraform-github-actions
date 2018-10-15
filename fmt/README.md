# Terraform Fmt Action
Runs `terraform fmt` to validate all Terraform files in a directory are in the canonical format.
 If any files differ, this action will comment back on the pull request with the diffs of each file.

See [https://www.terraform.io/docs/github-actions/actions/fmt.html](https://www.terraform.io/docs/github-actions/actions/fmt.html).
