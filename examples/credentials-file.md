# Terraform CLI Credentials File

The Terraform CLI credentials file is used to authenticate to Terraform Cloud/Enterprise. This is useful if the Terraform configuration contains many `terraform_remote_state` data sources that read from the same Terraform Cloud/Enterprise instance or if the configuration uses modules located in the Private Module Registry.

This example shows how to pass the hostname and token needed to create the CLI credentials file.

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
          tf_actions_cli_credentials_hostname: app.terraform.io 
          tf_actions_cli_credentials_token: ${{ secrets.TF_API_TOKEN }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terraform Plan'
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tf_actions_subcommand: 'plan'
          tf_actions_working_dir: '.'
```
