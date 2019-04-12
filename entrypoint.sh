#!/bin/bash

set -xe

echo "-----------------------------------------------------------"
echo "Processing $GITHUB_EVENT_PATH"
echo "-----------------------------------------------------------"

echo "### Printing environment"
env

echo "### Printing $GITHUB_EVENT_PATH"
jq . "$GITHUB_EVENT_PATH"

echo "### Making sure this is a pull prequest by looking for the PR URL"
(jq -r ".pull_request.issue.href" "$GITHUB_EVENT_PATH") || exit 78

echo "### Getting the head branch"
HEAD_BRANCH=$(jq -r .pull_request.base.repo.default_branch "$GITHUB_EVENT_PATH")

echo "### Getting branch to merge"
BRANCH_TO_MERGE=$(jq -r .pull_request.head.ref "$GITHUB_EVENT_PATH")

echo "### HEAD_BRANCH     = ${HEAD_BRANCH}"
echo "### BRANCH_TO_MERGE = ${BRANCH_TO_MERGE}"

echo "### Merging the Pull Request"
git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git config --global user.email "actions@github.com"
git config --global user.name "GitHub Merge Action"

set -o xtrace

git fetch origin $HEAD_BRANCH

# do the merge
git checkout -b $HEAD_BRANCH origin/$HEAD_BRANCH
git merge $BRANCH_TO_MERGE --no-edit
git push origin $HEAD_BRANCH
git push origin --delete $BRANCH_TO_MERGE
