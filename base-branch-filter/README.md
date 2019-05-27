# Base Branch Filter
Filters pull request events depending on the base branch
The base branch is the branch that the pull request will be merged into.

To use, set `args` to a regular expression that
will be matched against the destination branch.

Note: This action only works on pull request events.

## Example
Filter on pull requests that have been merged into `master`:
```hcl
workflow "example" {
  resolves = "base-branch-filter"
  # Must be used on pull_request events.
  on = "pull_request"
}

# First we use another filter to filter to only merged events.
action "merged-prs-filter" {
  uses = "actions/bin/filter@master"
  args = "merged true"
}

# Then we use this filter to ensure the branch matches "master".
action "base-branch-filter" {
  uses = "hashicorp/terraform-github-actions/base-branc-filter@master"
  # We set args to our regex.
  args = "^master$"
  needs = "merged-prs-filter"
}
```
