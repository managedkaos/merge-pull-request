#!/bin/bash

set -e

echo "-----------------------------------------------------------"
echo "Processing $GITHUB_EVENT_PATH"
echo "-----------------------------------------------------------"

echo "### printing environment"
env
jq . < $GITHUB_EVENT_PATH

echo "### checking for PR URL"
(jq -r ".issue.pull_request.url" "$EVENT_PATH") || exit 78

echo "### getting the PR number"
PR_NUMBER=$(jq -r ".issue.number" "$GITHUB_EVENT_PATH")

echo "### $PR_NUMBER"
