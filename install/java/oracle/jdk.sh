#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

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

JDK_URL="http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz"

apk add --update wget && \
wget -c --progress=dot:mega --no-check-certificate --no-cookies \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    ${JDK_URL} \
    -O /tmp/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz && \
mkdir -p /opt && \
tar --directory=/opt -xzf /tmp/${JAVA_PACKAGE}-${JAVA_VERSION}-linux-x64.tar.gz && \
ln -s `ls /opt/ | grep jdk` /opt/jdk && \
apk del wget


rm -rf \
    /opt/jdk/lib/visualvm/ \
    /opt/jdk/jre/lib/fonts/ \
    /opt/jdk/jre/lib/images/ && \
rm  -f /tmp/*.tar.gz \
    /opt/jdk/*src.zip \
    /opt/jdk/lib/*javafx*.jar \
    /opt/jdk/jre/lib/jfx*


JAVA_HOME=/opt/jdk
echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile.d/jdk.sh 
echo "export PATH=$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/jdk.sh  
chmod +x /etc/profile.d/jdk.sh