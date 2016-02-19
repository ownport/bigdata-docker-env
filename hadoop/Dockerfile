FROM ownport/oracle-server-jre:8u60

ARG HADOOP_VERSION

COPY ./scripts/install.sh /install/hadoop/install.sh

RUN /install/hadoop/install.sh hadoop && \
	/install/hadoop/install.sh set_env && \
	/install/hadoop/install.sh format_namenode

RUN /install/hadoop/install.sh sshd && \
	/install/hadoop/install.sh sshd_passwordless

COPY conf/*.xml /opt/hadoop/etc/hadoop/

CMD ["/sbin/runsvdir", "-P", "/etc/service"]


