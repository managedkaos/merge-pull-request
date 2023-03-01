# Merginator

This Action merges pull requests and deletes the branch associated with the PR.

# Environment Variables
- `GITHUB_TOKEN` - _Required_ Allows the Action to authenticte with the GitHub API.
- `GITHUB_HOST` - _Default: github.com_ Set it to `github.enterprise.com` to run on GHES

# Examples
Here's an example workflow that uses the Merginator.  The workflow is triggered by a `PULL_REQUEST` being opened or reopened and checks for the following before merging the PR:

- The PR author is one of "automate6500" or "octocat"
- The code associted with the PR passes all lints and unit tests
- The PR has been approved by the [Auto Approve Action](https://github.com/marketplace/actions/auto-approve)

```
name: Auto Merge Owner

on:
  pull_request:
    types: [opened, reopened]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@v3.3.0

    - uses: actions/setup-python@v4.5.0
      with:
        python-version: 3.11

    - name: flake8 and pylint
      run: |
        pip install -r requirements.txt
        flake8 --ignore=E501,E231 *.py tests/*.py
        pylint --errors-only --disable=C0301 --disable=C0326 *.py tests/*.py

    - name: unit test
      run: python -m unittest --verbose --failfast

  merge:
    if: github.actor == 'automate6500' || github.actor == 'octocat'
    needs: [lint]
    runs-on: ubuntu-latest
    steps:

    - uses: actions/checkout@v1

    - name: Auto Approve
      uses: hmarr/auto-approve-action@v3.1.0
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}

    - name: Pull Request Merginator
      uses: managedkaos/merge-pull-request@v2.2
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```