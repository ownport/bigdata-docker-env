#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :


[ -z ${ETCD_VERSION} ] && {
    echo '[ERROR] Environment variable ETCD_VERSION does not defined'
    exit 1
}

ETCD_URL="https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz"

apk add --update wget 

mkdir -p /opt /data && \
wget -c --progress=dot:mega --no-check-certificate -qO- ${ETCD_URL} | tar zxf - -C /opt && \
ln -s /opt/etcd-v${ETCD_VERSION}-linux-amd64/etcd /bin/etcd && \
ln -s /opt/etcd-v${ETCD_VERSION}-linux-amd64/etcdctl /bin/etcdctl && \
rm -rf /opt/etcd-v${ETCD_VERSION}-linux-amd64/Documentation && \
echo "[INFO] Installation of etcd [${ETCD_VERSION}] is completed" 

apk del wget && \
rm -rf /var/cache/apk/* /tmp/*  && \
echo '[INFO] Clearing is completed'    
