#!/bin/bash

set -e

USING_TOKEN=''
if [ -n "${INPUT_TOKEN}" ]; then
  USING_TOKEN="${INPUT_TOKEN}"
elif [ -n "${SPINNAKER_WEBHOOK_TOKEN}" ]; then
  USING_TOKEN="${SPINNAKER_WEBHOOK_TOKEN}"
else
  echo "no token found"
  exit 1
fi

USING_HOST=''
if [ -n "${INPUT_HOST}" ]; then
  USING_HOST="${INPUT_HOST}"
elif [ -n "${SPINNAKER_WEBHOOK_HOST}" ]; then
  USING_HOST="${SPINNAKER_WEBHOOK_HOST}"
else
  echo "no host found"
  exit 1
fi

USING_NAME=''
if [ -n "${INPUT_NAME}" ]; then
  USING_NAME="${INPUT_NAME}"
elif [ -n "${SPINNAKER_WEBHOOK_NAME}" ]; then
  USING_NAME="${SPINNAKER_WEBHOOK_NAME}"
else
  echo "no name found"
  exit 1
fi

USING_SHA="${GITHUB_SHA}"
if [ -n "${INPUT_SHA}" ]; then
  USING_SHA="${INPUT_SHA}"
elif [ -n "${SPINNAKER_WEBHOOK_SHA}" ]; then
  USING_SHA="${SPINNAKER_WEBHOOK_SHA}"
fi
if [ -z "${USING_SHA}" ]; then
  echo "no sha found"
  exit 1
fi

USING_EXTRA_PARAMS="{}"
if [ -n "${INPUT_EXTRA_PARAMS}" ]; then
  USING_EXTRA_PARAMS="${INPUT_EXTRA_PARAMS}"
elif [ -n "${SPINNAKER_WEBHOOK_EXTRA_PARAMS}" ]; then
  USING_EXTRA_PARAMS="${SPINNAKER_WEBHOOK_EXTRA_PARAMS}"
fi

message=$(git show --format=%s --no-patch $USING_SHA)
committer_name=$(git show --format=%an --no-patch $USING_SHA)
committer_email=$(git show --format=%ae --no-patch $USING_SHA)
webhook_body=$(jq --null-input \
  --join-output \
  --compact-output \
  --arg token "$USING_TOKEN" \
  --arg sha "$USING_SHA" \
  --arg message "$message" \
  --arg committer_name "$committer_name" \
  --arg committer_email "$committer_email" \
  --argjson extra_params "$USING_EXTRA_PARAMS" \
  '{
    $token,
    parameters: ({
      $sha,
      $message,
      $committer_name,
      $committer_email
    } + $extra_params)
  }'
)

echo "payload"
echo "$(echo "$webhook_body" | jq .)"

curl -X POST --fail --show-error \
  --data "$webhook_body" \
  --header 'Content-Type: application/json' \
  https://${USING_HOST}/webhooks/webhook/${USING_NAME}
