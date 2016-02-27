FROM alpine:latest

ARG CONSUL_VERSION
ARG CONSUL_SHA256
ARG WEBUI_SHA256

COPY ./scripts/install.sh /install/consul/install.sh

# export TRACE=true && 
RUN /install/consul/install.sh base && \
    /install/consul/install.sh glibc && \
    /install/consul/install.sh consul && \
    /install/consul/install.sh web_ui && \
    /install/consul/install.sh clean



