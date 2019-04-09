#!/bin/bash

set -e

if [ -n "$GITHUB_EVENT_PATH" ];
then
    EVENT_PATH=$GITHUB_EVENT_PATH
elif [ -f ./sample_pull_request_event.json ];
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

