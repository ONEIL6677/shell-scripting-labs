#!/bin/bash

#############################################################
# Script Name : list-users.sh
# Description : Lists all GitHub repository collaborators
#               with read (pull) access using the GitHub
#               REST API. Authenticates via a personal
#               access token and filters results using jq.
#
# Usage       : sh list-users.sh <REPO_OWNER> <REPO_NAME>
# Example     : sh list-users.sh my-org my-repo
#
# Arguments   :
#   $1 - REPO_OWNER : GitHub organization or username
#   $2 - REPO_NAME  : Name of the target repository
#
# Environment Variables (must be exported before running):
#   username - Your GitHub username
#   token    - Your GitHub personal access token (PAT)
#
# Pre-requisites : curl, jq
#
# Author      : ONEIL KIMBI
# Date        : June 2024
# Version     : 1.4
#############################################################

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token for authentication
USERNAME=$username
TOKEN=$token

# Command line arguments
REPO_OWNER=$1
REPO_NAME=$2

#############################################################
# Function: helper
# Description: Displays usage instructions and available
#              options when the script is called with -h,
#              --help, or with missing/invalid arguments.
#############################################################
function helper {
    echo "-----------------------------------------------"
    echo "         GitHub Repo Access Checker            "
    echo "-----------------------------------------------"
    echo ""
    echo "Description:"
    echo "  Lists all collaborators with READ (pull)"
    echo "  access to a given GitHub repository."
    echo ""
    echo "Usage:"
    echo "  sh list-users.sh <REPO_OWNER> <REPO_NAME>"
    echo ""
    echo "Arguments:"
    echo "  REPO_OWNER   GitHub organization or username"
    echo "  REPO_NAME    Name of the target repository"
    echo ""
    echo "Required Environment Variables:"
    echo "  username     Your GitHub username"
    echo "  token        Your GitHub personal access token"
    echo ""
    echo "Pre-requisites:"
    echo "  curl, jq"
    echo ""
    echo "Examples:"
    echo "  export username='my-user'"
    echo "  export token='ghp_xxxxxxxxxxxx'"
    echo "  sh list-users.sh my-org my-repo"
    echo ""
    echo "Options:"
    echo "  -h, --help   Show this help message and exit"
    echo "-----------------------------------------------"
    exit 0
}

# Show helper if -h or --help is passed
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    helper
fi

# Validate that both arguments are provided
if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
    echo "❌ Error: Missing required arguments."
    echo ""
    helper
fi

# Validate that environment variables are set
if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
    echo "❌ Error: Missing environment variables."
    echo "   Please export 'username' and 'token' before running."
    echo ""
    helper
fi

#############################################################
# Function: github_api_get
# Description: Makes an authenticated GET request to the
#              GitHub API and returns the JSON response.
#############################################################
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

#############################################################
# Function: list_users_with_read_access
# Description: Fetches and displays all collaborators with
#              read (pull) access to the specified repo.
#############################################################
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch collaborators and filter by pull access using jq
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # NB: To list admins instead, change the jq filter to:
    # jq -r '.[] | select(.permissions.admin == true) | .login'

    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access