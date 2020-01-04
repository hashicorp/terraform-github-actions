# Terraform Workspaces

The workspace can be specified using the `TF_WORKSPACE` environment variable.

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
          TF_WORKSPACE: dev
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

If using the `remote` backend with the `name` argument, the configured workspace will be created for you. If using the `remote` backend with the `prefix` argument, the configured workspace must already exist and will not be created for you.
