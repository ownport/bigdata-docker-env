#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :


echo "= /install/apache/hadoop.sh ============================================"
echo "Parameters:"
echo "FORMAT_NAMENODE=YES       format namenode"
echo "----------------------------------------------------------------------"


[ -z ${HADOOP_VERSION} ] && {
    echo '[ERROR] Environment variable HADOOP_VERSION does not defined '
    exit 1
} 

echo "hosts: files dns" >> /etc/nsswitch.conf

mkdir -p /tmp/hadoop /opt /data/hdfs

HADOOP_URL="http://www.eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

wget ${HADOOP_URL} -P /tmp/hadoop/ && \
tar --directory=/opt -xzf /tmp/hadoop/hadoop-${HADOOP_VERSION}.tar.gz

[ -d /opt/hadoop-${HADOOP_VERSION} ] && {
    ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop
}

rm -rf \
    /tmp/hadoop \
    /opt/hadoop/share/doc   

# ENV HADOOP_HOME /opt/hadoop
# ENV PATH $HADOOP_HOME/bin:$PATH   

## ENV HADOOP_COMMON_LIB_NATIVE_DIR ${HADOOP_HOME}/lib/native
## ENV HADOOP_PREFIX /opt/hadoop
## ENV HADOOP_COMMON_HOME /opt/hadoop
## ENV HADOOP_HDFS_HOME /opt/hadoop
## ENV HADOOP_MAPRED_HOME /opt/hadoop
## ENV HADOOP_YARN_HOME /opt/hadoop
## ENV HADOOP_CONF_DIR /opt/hadoop
## ENV HADOOP_OPTS='-Djava.library.path=${HADOOP_HOME}/lib'
## ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

HADOOP_HOME=/opt/hadoop
echo "export HADOOP_HOME=/opt/hadoop" >> /etc/profile.d/hadoop.sh 
echo "export PATH=$HADOOP_HOME/bin:$PATH" >> /etc/profile.d/hadoop.sh  
chmod +x /etc/profile.d/hadoop.sh   

sed -i '1s/^/source \/etc\/profile\n\n/' /opt/hadoop/etc/hadoop/hadoop-env.sh


if [ "${FORMAT_NAMENODE}" = "YES" ]
then
	JAVA_HOME=/opt/jdk ./opt/hadoop/bin/hdfs namenode -format
fi

