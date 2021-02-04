
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

Typical usage of this action looks like this:

    - uses: spinnaker-webhook
      with:
        token: ${{ secrets.SPINNAKER_TRIGGER_TOKEN }}
        host: spinnaker-host
        webhook: project-web-hook

You can also specify these environment variables to remove the with:

    SPINNAKER_TOKEN
    SPINNAKER_HOST
    SPINNAKER_WEBHOOK
