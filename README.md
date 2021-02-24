# spinnaker-webhook

[![Spinnaker Webhook Tests](https://github.com/instructure-bridge/spinnaker-webhook/actions/workflows/ci.yaml/badge.svg)](https://github.com/instructure-bridge/spinnaker-webhook/actions/workflows/ci.yaml)
![tag](https://img.shields.io/github/v/tag/instructure-bridge/spinnaker-webhook?sort=semver)

This action will call the spinnaker webhook with a payload that looks
like this:

    {
      "token": "${TOKEN}",
      "parameters": {
        "sha": "${GITHUB_SHA}",
        "message": "${COMMIT_MESSAGE}",
        "committer_name": "${COMMITTER_NAME}",
        "committer_email": "${COMMITTER_EMAIL}"
      }
    }

## Usage

Typical usage of this action looks like this:

    - uses: instructure-bridge/spinnaker-webhook@v1
      with:
        token: ${{ secrets.SPINNAKER_TRIGGER_TOKEN }}
        host: spinnaker-host
        webhook: project-web-hook

You can also specify these environment variables to remove the with:

    SPINNAKER_WEBHOOK_TOKEN
    SPINNAKER_WEBHOOK_HOST
    SPINNAKER_WEBHOOK_WEBHOOK
    SPINNAKER_WEBHOOK_SHA
    SPINNAKER_WEBHOOK_EXTRA_PARAMS
