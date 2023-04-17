#!/bin/bash

# Set the label value to filter the pull requests
LABEL_VALUE="Done"

# Get the list of pull requests with the specified label value
PULL_REQUESTS=$(curl -s "https://api.github.com/repos/seepala98/Automerge_PR_on_Label/pulls?state=open&labels=$LABEL_VALUE" | jq -r '.[].number')
echo $PULL_REQUESTS

# # Loop through the pull requests and merge them if they meet the requirements
# for PR_NUMBER in $PULL_REQUESTS
# do
#     # Get the pull request details
#     PR_DETAILS=$(curl -s "https://api.github.com/repos/<username>/<repository>/pulls/$PR_NUMBER")
    
#     # Check if the pull request is mergeable
#     MERGEABLE=$(echo "$PR_DETAILS" | jq -r '.mergeable')
    
#     # Check if the pull request has been approved
#     APPROVED=$(echo "$PR_DETAILS" | jq -r '.reviews | map(select(.state == "APPROVED")) | length')
    
#     # Check if the pull request has passed all checks
#     CHECKS=$(echo "$PR_DETAILS" | jq -r '.statuses | map(select(.state != "success")) | length')
    
#     # If the pull request is mergeable, approved, and has passed all checks, merge it
#     if [[ "$MERGEABLE" == "true" && "$APPROVED" -gt 0 && "$CHECKS" -eq 0 ]]; then
#         # Merge the pull request
#         curl -X PUT -H "Authorization: token <access_token>" "https://api.github.com/repos/<username>/<repository>/pulls/$PR_NUMBER/merge"

#         # Print a message indicating that the pull request was merged
#         echo "Pull request #$PR_NUMBER merged"
#     else
#         # Print a message indicating that the pull request was not merged
#         echo "Pull request #$PR_NUMBER not merged"
#     fi
# done

# UPdateing so it can be a conflict 