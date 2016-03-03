#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

echo "= /install/alpine/runit.sh ============================================"

echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
apk add --update runit && \
rm -rf /var/cache/apk/* 


