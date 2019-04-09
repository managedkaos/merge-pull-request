#!/bin/bash

set -e

if [ -n "$GITHUB_EVENT_PATH" ];
then
    EVENT_PATH=$GITHUB_EVENT_PATH
elif [ -f ./sample_push_event.json ];
then
    EVENT_PATH='./sample_pull_request_event.json'
    LOCAL_TEST=true
else
    echo "No JSON data to process! :("
    exit 1
fi

echo "-----------------------------------------------------------"
echo "Processing $EVENT_PATH"
echo "-----------------------------------------------------------"

echo "### printing environment"
env
jq . < $EVENT_PATH

echo "### checking for PR URL"
(jq -r ".issue.pull_request.url" "$EVENT_PATH") || exit 78

echo "### getting the PR number"
PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")


URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}/pulls/${PR_NUMBER}")

HEAD_REPO=$(echo "$pr_resp" | jq -r .head.repo.full_name)
HEAD_BRANCH=$(echo "$pr_resp" | jq -r .head.ref)

git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "actions@github.com"
git config --global user.name "GitHub Merge Action"

set -o xtrace

git fetch origin $HEAD_BRANCH

# do the merge
git checkout -b $HEAD_BRANCH origin/$HEAD_BRANCH
git merge $BRANCH_TO_MERGE --no-edit
git push origin $HEAD_BRANCH
