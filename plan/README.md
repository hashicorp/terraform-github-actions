# Terraform Plan Action
Runs `terraform plan` and comments back on the pull request with the plan output.

# Env Variables

If `TF_WORKSPACE_FORCE_CREATE` is set to true when plan is executed and the given workspace doesn't exist the `plan` command will create it for you.

# Example

```
jobs:
  greeting:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Set branch name as workspace
      run: echo ::set-env name=TF_ACTION_WORKSPACE::${GITHUB_REF##*/}
    - uses: hashicorp/terraform-github-actions/init@v0.4.6
    - uses: hashicorp/terraform-github-actions/plan@v<current_version>
      env:
       TF_WORKSPACE_FORCE_CREATE: true
```

See [https://www.terraform.io/docs/github-actions/actions/plan.html](https://www.terraform.io/docs/github-actions/actions/plan.html).
