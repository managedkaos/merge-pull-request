#!/bin/bash

set -xe

echo "-----------------------------------------------------------"
echo "Processing $GITHUB_EVENT_PATH"
echo "-----------------------------------------------------------"

echo "### printing environment"
env
jq . < $GITHUB_EVENT_PATH

echo "### checking for PR URL"
(jq -r ".pull_request.issue.href" "$GITHUB_EVENT_PATH") || exit 78

echo "### getting the PR number"
PR_NUMBER=$(jq -r ".number" "$GITHUB_EVENT_PATH")

echo "### $PR_NUMBER"
