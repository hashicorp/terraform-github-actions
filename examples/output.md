# Terraform Output

If you need the outputs of your Terraform configuration later in your GitHub Actions workflow, you can use the `output` subcommand.

```yaml
name: 'Terraform GitHub Actions'
on:
  - push
jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master

      - name: 'Terraform Outputs'
        id: terraform
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tf_actions_subcommand: 'outputs'
          tf_actions_working_dir: '.'

      - name: 'Use Terraform Output'
        run: echo ${{ steps.terraform.outputs.tf_actions_output  }}

      - name: 'Pull specific database name from outputs'
        run: |
          # Install jq in this shell
          apt-get install jq

          # Parse the outputs from the 'Terraform Outputs' step and grab the database name
          DBNAME=$(echo ${{ steps.terraform.outputs.tf_actions_output }} | jq -r '.database.value.name')

          # Will echo out 'test-database'
          echo $DBNAME
```

In this example the `tf_actions_output` would look like:
```json
{
  "database": {
    "value": {
      "name": "test-database"
    }
  }
}
```