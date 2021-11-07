#!/usr/bin/env bash
set -e

# Check if necessary environment variables are set
if [[ -z $UISP_DOMAIN ]]; then
  echo "One or more variables are undefined."
  echo "The following must be set:"
  echo "- UISP_DOMAIN"
  exit 1
fi

# Check if UISP API token exists
if [[ -z $UISP_API_TOKEN && ! -f "/run/secrets/uisp_api_token" ]]; then
  echo "The UISP API token cannot be found."
  echo "The following must be set:"
  echo "- UISP_API_TOKEN (will also check /run/secrets/uisp_api_token)"
  exit 1
elif [[ -z $UISP_API_TOKEN ]]; then
  export UISP_API_TOKEN=$(cat /run/secrets/uisp_api_token)
fi

# Define API routes
backups_route="${UISP_DOMAIN}/nms/api/v2.1/nms/backups"

# Variables to store latest backup object and subkeys
latest_backup=$(curl -s -X GET $backups_route -H "accept: application/json" -H "x-auth-token: ${UISP_API_TOKEN}" | jq -r '. |= sort_by(.createdAt) | .[-1]')
backup_id=$(echo $latest_backup | jq -r '.id')
backup_filename="backup-$(echo $latest_backup | jq -r '.createdAt').uisp"

# Download latest backup file
echo "Downloading latest backup [${backup_id}]"
curl -s -o /backups/${backup_filename} ${backups_route}/${backup_id} -H "accept: application/json" -H "x-auth-token: ${UISP_API_TOKEN}"
echo "Done"
