FROM alpine:latest

ARG LOCAL_REPO
ARG ETCD_VERSION

RUN wget -O - http://${LOCAL_REPO}/install/etcd.sh | sh -s

CMD ["/bin/etcd", "-data-dir=/data"]


