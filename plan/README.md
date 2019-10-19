# Terraform Plan Action
Runs `terraform plan` and comments back on the pull request with the plan output.

# Env Variables

If `TF_WORKSPACE_FORCE_CREATE` is set to true when plan is executed and the given workspace doesn't exist the `plan` command will create it for you.


See [https://www.terraform.io/docs/github-actions/actions/plan.html](https://www.terraform.io/docs/github-actions/actions/plan.html).
