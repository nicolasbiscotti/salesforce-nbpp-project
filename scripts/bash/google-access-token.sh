#!/bin/bash

# Load client credentials
CLIENT_ID=$(jq -r '.installed.client_id' credentials.json)
CLIENT_SECRET=$(jq -r '.installed.client_secret' credentials.json)
REDIRECT_URI=$(jq -r '.installed.redirect_uris[0]' credentials.json)

# Generate OAuth URL
AUTH_URL="https://accounts.google.com/o/oauth2/v2/auth?client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&response_type=code&scope=https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/presentations&access_type=offline"
echo "Open the following URL in your browser to authorize the application:"
echo $AUTH_URL

# Prompt user for authorization code
read -p "Enter the authorization code: " AUTH_CODE

# Exchange authorization code for access token
RESPONSE=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -d code=${AUTH_CODE} \
  -d client_id=${CLIENT_ID} \
  -d client_secret=${CLIENT_SECRET} \
  -d redirect_uri=${REDIRECT_URI} \
  -d grant_type=authorization_code)

# Extract and display access token
ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')
echo "Access Token: $ACCESS_TOKEN"
