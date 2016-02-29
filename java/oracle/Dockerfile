FROM alpine:latest

ARG JAVA_PACKAGE
ARG JAVA_VERSION 
ARG JAVA_VERSION_BUILD

RUN apk add --update bash wget && rm -rf /var/cache/apk/*

COPY ./scripts/install.sh /install/jdk/install.sh

RUN /install/jdk/install.sh all

