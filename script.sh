#!/bin/sh

set -eu

: "${API_KEY:?API_KEY is required}"
CRON_SCHEDULE="${CRON_SCHEDULE:-0 * * * *}"
API_URL="${API_URL:-https://ai.example.com/v1/chat/completions}"
MODEL="${MODEL:-claude-haiku-5-5}"
PROMPT="${PROMPT:-Hello!}"
LOG_FILE="${LOG_FILE:-/proc/1/fd/1}"

set -f
# shellcheck disable=SC2086
set -- $CRON_SCHEDULE
set +f
if [ "$#" -ne 5 ]; then
    echo "error: CRON_SCHEDULE must have 5 fields (got $#): '$CRON_SCHEDULE'" >&2
    exit 1
fi

quote() { printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"; }
umask 077
{
    echo "API_KEY=$(quote "$API_KEY")"
    echo "API_URL=$(quote "$API_URL")"
    echo "MODEL=$(quote "$MODEL")"
    echo "PROMPT=$(quote "$PROMPT")"
} > /etc/cron-job.env

echo "$CRON_SCHEDULE /usr/local/bin/job.sh >> $LOG_FILE 2>&1" | crontab -
echo "Installed cron job: $CRON_SCHEDULE -> $API_URL ($MODEL)"

exec crond -f
