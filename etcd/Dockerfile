FROM alpine:latest

ARG ETCD_VERSION

COPY ./scripts/install.sh /install/etcd/install.sh

RUN /install/etcd/install.sh base && \
	/install/etcd/install.sh etcd && \
	/install/etcd/install.sh clean

CMD ["/bin/etcd", "-data-dir=/data"]


