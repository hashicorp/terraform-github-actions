# Terraform Fmt Action
Runs `terraform fmt` to validate all Terraform files in a directory are in the canonical format.
If any files differ, this action will comment back on the pull request with the diffs of each file.

## Success Criteria
This action succeeds if `terraform fmt` runs without error.

## Usage
To use the `fmt` action, add it to your workflow file.

```workflow
action "terraform fmt" {
  # Replace <latest tag> with the latest tag from https://github.com/hashicorp/terraform-github-actions/releases.
  uses = "hashicorp/terraform-github-actions/fmt@<latest tag>"
  
  # See Environment Variables below for details.
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
  
  # We need the GitHub token to be able to comment back on the pull request.
  secrets = ["GITHUB_TOKEN"]
}
```

## Environment Variables
| Name                    | Default   | Description                                                                      |
|-------------------------|-----------|----------------------------------------------------------------------------------|
| `TF_ACTION_WORKING_DIR` | `"."`     | Which directory `fmt` runs in. Relative to the root of the repo.            |
| `TF_ACTION_COMMENT`     | `"true"`  | Set to `"false"` to disable commenting back on pull request with the diffs of unformatted files. |


## Secrets
The `GITHUB_TOKEN` secret is required for posting a comment back to the pull request if `fmt` fails.

If you have set `TF_ACTION_COMMENT = "false"`, then `GITHUB_TOKEN` is not required.

## Arguments
Any arguments will be appended to the `terraform fmt` command however we do not anticipate that this will be needed.
