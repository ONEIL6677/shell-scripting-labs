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
# Date        : June 2023
# Version     : 1.4
#############################################################


# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token for authentication
USERNAME=$username #here the username will be exported from terminal or environment
TOKEN=$token  #here the github API access token will be exported from terminal or environment

# User and Repository information to be pers to the command before running the script
# eg sh list-user.sh organisatioName RepositoryName
REPO_OWNER=$1 #command line argurmnet 1 which is organisatioName
REPO_NAME=$2 #command line argurmnet 2 which is RepositoryName

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    # with jq command which helps to filter pout complex json file 
    # and print out only usernames of users who have access
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # NB if you want to get all the admins of this repo change the jq command above to 
    # jq -r '.[] | select(.permissions.admin == true) | .login')"


    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then #if list of colaborators is empty print
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else #if list of colaborators is not empty then print the list
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
