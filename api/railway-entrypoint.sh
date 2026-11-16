#!/bin/sh
# Loads the shared webhook-signing key (see rsa-key.rb), then runs Lago's own start script.
set -e
if [ -z "${LAGO_RSA_PRIVATE_KEY:-}" ]; then
  LAGO_RSA_PRIVATE_KEY="$(bundle exec ruby /railway/rsa-key.rb)"
  export LAGO_RSA_PRIVATE_KEY
fi
exec "$@"
