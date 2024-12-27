#!/bin/bash

# Path to the credentials JSON file (three folders up)
json_file="/home/nicolas/Code/NBPP_Developer_Environment/nbppProject/nbpp-credentials-8220b2d86a80.json"

# Load values from the JSON file
client_email=$(jq -r '.client_email' "$json_file")
private_key=$(jq -r '.private_key' "$json_file" | sed 's/\\n/\n/g')
token_uri=$(jq -r '.token_uri' "$json_file")

# Define the JWT claim set
current_time=$(date +%s)
expire_time=$(($current_time + 3600)) # 1 hour expiration

header=$(echo -n '{"alg":"RS256","typ":"JWT"}' | openssl base64 -e -A | tr -d '=' | tr '/+' '_-' | tr -d '\n')
payload=$(echo -n "{\"iss\":\"$client_email\",\"scope\":\"https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/presentations\",\"aud\":\"$token_uri\",\"exp\":$expire_time,\"iat\":$current_time}" | openssl base64 -e -A | tr -d '=' | tr '/+' '_-' | tr -d '\n')

# Create the JWT assertion
signature=$(echo -n "$header.$payload" | openssl dgst -sha256 -sign <(echo -n "$private_key") | openssl base64 -e -A | tr -d '=' | tr '/+' '_-' | tr -d '\n')
jwt="$header.$payload.$signature"

# Exchange the JWT for an access token
response=$(curl -s -X POST "$token_uri" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=$jwt")

# Extract and display the access token
access_token=$(echo $response | jq -r '.access_token')
echo "Access Token: $access_token"

echo $(curl POST \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $access_token" \
     -d '{
           "slideId": "YOUR_SLIDE_ID",
           "shapeId": "YOUR_SHAPE_ID",
           "newText": "Your New Text Content"
         }' \
     "https://script.google.com/macros/s/AKfycbwsAKnQDJN0lvYnfnq1LKqv8TUku3NXzzpRmPkpXcM/dev" -v)


