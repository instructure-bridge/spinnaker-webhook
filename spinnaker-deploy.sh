#!/bin/bash

set -ex

USING_TOKEN=''
if [ -n "${INPUT_TOKEN}" ]; then
  USING_TOKEN="${INPUT_TOKEN}"
elif [ -n "${SPINNAKER_TOKEN}" ]; then
  USING_TOKEN="${SPINNAKER_TOKEN}"
else
  echo "no token found"
  exit 1
fi

USING_HOST=''
if [ -n "${INPUT_HOST}" ]; then
  USING_HOST="${INPUT_HOST}"
elif [ -n "${SPINNAKER_HOST}" ]; then
  USING_HOST="${SPINNAKER_HOST}"
else
  echo "no host found"
  exit 1
fi

USING_WEBHOOK=''
if [ -n "${INPUT_WEBHOOK}" ]; then
  USING_WEBHOOK="${INPUT_WEBHOOK}"
elif [ -n "${SPINNAKER_WEBHOOK}" ]; then
  USING_WEBHOOK="${SPINNAKER_WEBHOOK}"
else
  echo "no webhook found"
  exit 1
fi

USING_SHA="${GITHUB_SHA}"
if [ -n "${INPUT_SHA}" ]; then
  USING_SHA="${INPUT_SHA}"
fi
if [ -z "${USING_SHA}" ]; then
  echo "no sha found"
  exit 1
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
  '{
    $token,
    parameters: {
      $sha,
      $message,
      $committer_name,
      $committer_email
    }
  }'
)

curl -X POST --fail --show-error \
  --data "$webhook_body" \
  --header 'Content-Type: application/json' \
  https://${USING_HOST}/webhooks/webhook/${USING_WEBHOOK}
