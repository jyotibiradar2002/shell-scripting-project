#!/bin/bash

##########################
# Author : Jyoti
# Date : 22 March
# Purpose : Display who has access to repository
# Version : 1
##########################

# GitHub URL
api_url="https://api.github.com"

# GitHub credentials (export before running)
username="$username"
token="$token"

# User and repository info
repo_owner="$1"
repo_name="$2"

# Helper function
helper() {
    expected_cmd_arg=2

    if [ $# -ne $expected_cmd_arg ]; then
        echo "Usage: $0 <repo_owner> <repo_name>"
        exit 1
    fi
}

# Function to call GitHub API
github_api_get() {
    local endpoint="$1"
    local url="${api_url}/${endpoint}"

    curl -s -u "${username}:${token}" "${url}"
}

# Function to list users
list_user_with_read_access() {
    local endpoint="repos/${repo_owner}/${repo_name}/collaborators"

    collaborators=$(github_api_get "$endpoint" | jq -r '.[]? | select(.permissions.pull == true) | .login')

    if [ -z "$collaborators" ]; then
        echo "No users with read access found for ${repo_owner}/${repo_name}"
    else
        echo "Users with read access for ${repo_owner}/${repo_name}:"
        echo "$collaborators"
    fi
}

# Call helper FIRST
helper "$@"

# Main
echo "Fetching users with read access for ${repo_owner}/${repo_name}..."

list_user_with_read_access
