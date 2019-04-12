# Merginator

This Action merges pull requests and deletes the branch associated with the PR.

# Secrets
- `GITHUB_TOKEN` - _Required_ Allows the Action to authenticte with the GitHub API.

# Environment Variables
- N/A

# Arguments
- N/A

# Examples
Here's an example workflow that uses the Merginator.  The workflow is triggered by a `PULL_REQUEST` and checks for the following before merging the PR:
- The PR author is one of "managedkaos" or "octocat"
- The code associted with the PR passes `pylint app.py`
- The PR has been approved by the [Auto Approve Action](https://github.com/marketplace/actions/auto-approve)

```
workflow "The Main Workflow REAL DEAL" {
  resolves = ["managedkaos/merge-pull-request@master"]
  on = "pull_request"
}

action "Filters for GitHub Actions-actor" {
  uses = "actions/bin/filter@3c98a2679187369a2116d4f311568596d3725740"
  args = "actor managedkaos"
}

action "GitHub Action for pylint" {
  uses = "cclauss/GitHub-Action-for-pylint@master"
  args = "pip install -r requirements.txt ; pylint app.py"
}

action "Auto Approve" {
  needs = ["Filters for GitHub Actions-actor", "GitHub Action for pylint"]
  uses = "hmarr/auto-approve-action@master"
  secrets = ["GITHUB_TOKEN"]
}

action "managedkaos/merge-pull-request@master" {
  uses = "managedkaos/merge-pull-request@master"
  needs = ["Auto Approve"]
  secrets = ["GITHUB_TOKEN"]
}
```


