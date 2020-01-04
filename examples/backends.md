# Terraform Backends

Terraform GitHub Actions supports initializing a `backend` block using the `-backend-config` option.

The example below shows how to pass the `token` and `organization` arguments to the `remote` backend block. The `token` argument is passed using GitHub Actions secrets while the organization is hardcoded.

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
          args: '-backend-config="token=${{ secrets.TF_API_TOKEN }}" -backend-config="organization=CHANGE_ME"'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
