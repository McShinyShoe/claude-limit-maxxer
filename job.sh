#!/bin/sh

set -eu
. /etc/cron-job.env

body="$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" \
    '{model: $model, messages: [{role: "user", content: $prompt}]}')"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] POST $API_URL"
curl -sS --fail-with-body --max-time 120 -X POST "$API_URL" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$body"
echo
