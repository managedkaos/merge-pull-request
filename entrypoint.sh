#!/bin/bash

set -xe

echo "-----------------------------------------------------------"
echo "Processing $GITHUB_EVENT_PATH"
echo "-----------------------------------------------------------"

echo "### Printing environment"
env

# Fix for unsafe path issue https://github.blog/2022-04-12-git-security-vulnerability-announced/
# in git when running inside docker container
git config --global --add safe.directory /github/workspace

echo "### Printing $GITHUB_EVENT_PATH"
jq . "$GITHUB_EVENT_PATH"

echo "### Making sure this is a pull prequest by looking for the PR URL"
(jq -r ".pull_request.issue.href" "$GITHUB_EVENT_PATH") || exit 78

echo "### Getting the head branch"
HEAD_BRANCH=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")

echo "### Getting branch to merge"
BRANCH_TO_MERGE=$(jq -r .pull_request.head.ref "$GITHUB_EVENT_PATH")

echo "### HEAD_BRANCH     = ${HEAD_BRANCH}"
echo "### BRANCH_TO_MERGE = ${BRANCH_TO_MERGE}"

echo "### Merging the Pull Request"
git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@${GITHUB_HOST:-github.com}/${GITHUB_REPOSITORY}.git
git config --global user.email "actions@github.com"
git config --global user.name "GitHub Merge Action"

set -o xtrace

git fetch origin $HEAD_BRANCH

# do the merge
git checkout -b $HEAD_BRANCH origin/$HEAD_BRANCH
git fetch origin $BRANCH_TO_MERGE
git merge origin/$BRANCH_TO_MERGE --no-edit
git push origin $HEAD_BRANCH
git push origin --delete $BRANCH_TO_MERGE
