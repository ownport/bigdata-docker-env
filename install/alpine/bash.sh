#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

apk add --update bash && rm -rf /var/cache/apk/*
