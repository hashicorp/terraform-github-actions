#!/bin/sh

set -e

regex="$*"
base_branch=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")

if "$actual" | grep -q "$regex"; then
  echo "base branch \"$base_branch\" does not match \"$regex\""
  exit 78
fi
