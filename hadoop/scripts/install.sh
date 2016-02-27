#!/bin/bash

set -e

sshd() {

    echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --update openssh runit && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/service/sshd && \
    printf "#!/bin/sh\nexec /usr/sbin/sshd -D -f /etc/ssh/sshd_config" > /etc/service/sshd/run && \
    chmod +x /etc/service/sshd/run && \
    /usr/bin/ssh-keygen -A
}

sshd_passwordless() {

    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
}


hadoop() {

    [ -z ${HADOOP_VERSION} ] && {
        echo '[ERROR] Environment variable HADOOP_VERSION does not defined '
        exit 1
    } 

    echo "hosts: files dns" >> /etc/nsswitch.conf

    mkdir -p /tmp/hadoop /opt /data/hdfs

    wget -c --progress=dot:mega --no-check-certificate \
        http://www.eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
        -P /tmp/hadoop/ && \
    tar --directory=/opt -xzf /tmp/hadoop/hadoop-${HADOOP_VERSION}.tar.gz

    [ -d /opt/hadoop-${HADOOP_VERSION} ] && {
        ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop
    }

    rm -rf \
        /tmp/hadoop \
        /opt/hadoop/share/doc   
}

set_env() {

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
}

format_namenode() {
    
    JAVA_HOME=/opt/jdk ./opt/hadoop/bin/hdfs namenode -format
}

$@

