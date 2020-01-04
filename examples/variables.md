# Terraform Variables

Variables can be configured directly in the GitHub Actions workflow YAML a few ways.

## Using Arguments

This example shows how to pass variables using the `-var` argument.

```yaml
name: 'Terraform GitHub Actions'
on:
  - pull_request
jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terraform Init'
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
          args: '-var="env=dev"'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This example shows how to use a variable file using the `-var-file` argument.

```yaml
name: 'Terraform GitHub Actions'
on:
  - pull_request
jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terraform Init'
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
          args: '-var-file="dev.tfvars"'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```


## Using an Environment Variable

The `TF_VAR_name` environment variable can be used to define a value for a variable. When using `TF_VAR_name`,`name` is the name of the Terraform variable as declared in the Terraform files.

Here, the Terraform variable `env` is set to the value `dev`.

```yaml
name: 'Terraform GitHub Actions'
on:
  - pull_request
jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terraform Init'
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
        env:
          TF_VAR_env: 'dev'
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
