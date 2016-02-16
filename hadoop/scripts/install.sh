#!/bin/bash

sshd() {

	echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --update openssh runit && rm -rf /var/cache/apk/* && \
	mkdir -p mkdir -p /etc/service/sshd && \
	printf "#!/bin/sh\nexec /usr/sbin/sshd -D -f /etc/ssh/sshd_config" > /etc/service/sshd/run && \
	chmod +x /etc/service/sshd/run && \
	/usr/bin/ssh-keygen -A
}


hadoop() {

	[ -z ${HADOOP_VERSION} ] && {
		echo '[ERROR] Environment variable HADOOP_VERSION does not defined '
		exit 1
	} 

	echo "hosts: files dns" >> /etc/nsswitch.conf

	mkdir -p /tmp/hadoop /opt

	wget -c --progress=dot:mega --no-check-certificate \
		http://www.eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
		-P /tmp/hadoop/ && \
    tar --directory=/opt -xzf /tmp/hadoop/hadoop-${HADOOP_VERSION}.tar.gz && \
    ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop && \ 
    rm -rf /tmp/hadoop 	
}

$@

