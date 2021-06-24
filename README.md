# spinnaker-webhook

[![Spinnaker Webhook Tests](https://github.com/get-bridge/spinnaker-webhook/actions/workflows/ci.yaml/badge.svg)](https://github.com/get-bridge/spinnaker-webhook/actions/workflows/ci.yaml)
![tag](https://img.shields.io/github/v/tag/get-bridge/spinnaker-webhook?sort=semver)

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

    - uses: get-bridge/spinnaker-webhook@v2
      with:
        token: ${{ secrets.SPINNAKER_TRIGGER_TOKEN }}
        host: spinnaker-host
        name: project-web-hook

You can also specify these environment variables to remove the with:

    SPINNAKER_WEBHOOK_TOKEN
    SPINNAKER_WEBHOOK_HOST
    SPINNAKER_WEBHOOK_NAME
    SPINNAKER_WEBHOOK_SHA
    SPINNAKER_WEBHOOK_EXTRA_PARAMS
