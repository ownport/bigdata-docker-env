FROM ownport/oracle-server-jre:8u60

ARG LOCAL_REPO
ARG HADOOP_VERSION

RUN wget -O - http://${LOCAL_REPO}/install/alpine/bash.sh | sh -s && \
	wget -O - http://${LOCAL_REPO}/install/alpine/runit.sh | sh -s && \
	wget -O - http://${LOCAL_REPO}/install/alpine/sshd.sh | \
		RUNIT_SUPPORT=YES \
		PASSWORDLESS_MODE=YES \
		sh -s
	
RUN wget -O - http://${LOCAL_REPO}/install/apache/hadoop.sh | \
		FORMAT_NAMENODE=YES \
			sh -s 

COPY ./conf/*.xml /opt/hadoop/etc/hadoop/

CMD ["/sbin/runsvdir", "-P", "/etc/service"]


