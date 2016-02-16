#!/bin/bash

install_glibc() {
	apk add --update bash wget && \
    wget -c --progress=dot:mega --no-check-certificate \
        https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk \
        -O /tmp/glibc-2.21-r2.apk && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
    rm /tmp/glibc-2.21-r2.apk && \
    rm -rf /var/cache/apk/*
}

install_java() {

	[ -z ${JAVA_PACKAGE} ] && {
		echo '[ERROR] Environment variable JAVA_PACKAGE does not defined'
		exit 1
	}

	[ -z ${JAVA_VERSION} ] && {
		echo '[ERROR] Environment variable JAVA_VERSION does not defined'
		exit 1
	}

	[ -z ${JAVA_VERSION_BUILD} ] && {
		echo '[ERROR] Environment variable JAVA_VERSION_BUILD does not defined'
		exit 1
	}

	wget -c --progress=dot:mega --no-check-certificate --no-cookies \
        --header "Cookie: oraclelicense=accept-securebackup-cookie" \
        http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz \
        -O /tmp/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz && \
    mkdir -p /opt && \
    tar --directory=/opt -xzf /tmp/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz && \
	ln -s `ls /opt/ | grep jdk` /opt/jdk && \
    rm -rf \
        /opt/jdk/lib/visualvm/ \
        /opt/jdk/jre/lib/fonts/ \
        /opt/jdk/jre/lib/images/ && \
    rm  -f /tmp/*.tar.gz \
        /opt/jdk/*src.zip \
        /opt/jdk/lib/*javafx*.jar \
        /opt/jdk/jre/lib/jfx*
}

$@
