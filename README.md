# Terraform GitHub Actions
These official Terraform GitHub Actions allow you to run `terraform fmt`, `validate`, `plan` and `apply` on your pull requests to help you review, validate and apply Terraform changes.

## Getting Started
To get started, check out our documentation: [https://www.terraform.io/docs/github-actions/getting-started/](https://www.terraform.io/docs/github-actions/getting-started/).

## Actions

### Fmt Action
Runs `terraform fmt` and comments back if any files are not formatted correctly.
<img src="./assets/fmt.png" alt="Terraform Fmt Action" width="80%" />

### Validate Action
Runs `terraform validate` and comments back on error.
<img src="./assets/validate.png" alt="Terraform Validate Action" width="80%" />

### Plan Action
Runs `terraform plan` and comments back with the output.
<img src="./assets/plan.png" alt="Terraform Plan Action" width="80%" />

### Apply Action
Runs `terraform apply` and comments back with the output.
<img src="./assets/apply.png" alt="Terraform Apply Action" width="80%" />