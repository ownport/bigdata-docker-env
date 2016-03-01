#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

GLIBC_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk"

apk add --update wget && \
wget -c --progress=dot:mega --no-check-certificate ${GLIBC_URL} \
    -O /tmp/glibc-2.21-r2.apk && \
apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
apk del wget && \
rm /tmp/glibc-2.21-r2.apk && \
rm -rf /var/cache/apk/*
