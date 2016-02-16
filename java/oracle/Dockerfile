FROM alpine:latest

ARG JAVA_PACKAGE
ARG JAVA_VERSION 
ARG JAVA_VERSION_BUILD

RUN apk add --update bash wget && rm -rf /var/cache/apk/*

COPY scripts/install.sh /usr/local/bin/jdk-install.sh

RUN /usr/local/bin/jdk-install.sh \
        install_glibc

RUN /usr/local/bin/jdk-install.sh \
        install_java 

ENV JAVA_HOME /opt/jdk
ENV PATH $JAVA_HOME/bin:$PATH
