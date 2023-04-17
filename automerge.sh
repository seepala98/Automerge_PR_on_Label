#!/bin/bash

# Check if the script was called with the correct number of arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <username> <repository>"
    exit 1
fi

# Set the username and repository variables based on the script arguments
USERNAME="$1"
REPOSITORY="$2"

# Set the label value to filter the pull requests
LABEL_VALUE="Done"

# Get the list of pull requests with the specified label value
PULL_REQUESTS=$(curl -s "https://api.github.com/repos/$USERNAME/$REPOSITORY/pulls?state=open&labels=$LABEL_VALUE" | jq -r '.[].number')
echo $PULL_REQUESTS

# # Loop through the pull requests and merge them if they meet the requirements
for PR_NUMBER in $PULL_REQUESTS
do
    # Get the pull request details
    PR_DETAILS=$(curl -s "https://api.github.com/repos/$USERNAME/$REPOSITORY/pulls/$PR_NUMBER")
    echo $PR_DETAILS
    # Check if the pull request is mergeable
    MERGEABLE=$(echo "$PR_DETAILS" | jq -r '.mergeable')
    echo $MERGEABLE
    # check of the pull request has been approved 
    APPROVED=$(echo "$PR_DETAILS" | jq -r '.requested_reviewers')
    echo $APPROVED
    # check if the pull request has passed all checks 
    CHECKS=$(echo "$PR_DETAILS" | jq -r '.mergeable_state')
    echo $CHECKS
    # check if the PR is already merged 
    MERGED=$(echo "$PR_DETAILS" | jq -r '.merged')
    echo $MERGED
    # If the pull request is mergeable, approved, and has passed all checks, merge it
    if [[ "$MERGEABLE" == "true" && "$CHECKS" == "clean" && "$MERGED" == "false" ]]; then
        # Merge the pull request
        curl -X PUT -H "Authorization: token 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" "https://api.github.com/repos/$USERNAME/$REPOSITORY/pulls/$PR_NUMBER/merge"

        # Print a message indicating that the pull request was merged
        echo "Pull request #$PR_NUMBER merged"
    else
        # Print a message indicating that the pull request was not merged
        echo "Pull request #$PR_NUMBER not merged"
    fi
done
