FROM ownport/oracle-server-jre:8u60

ARG HADOOP_VERSION

COPY scripts/install.sh /usr/local/bin/hadoop-install.sh

RUN /usr/local/bin/hadoop-install.sh sshd
RUN /usr/local/bin/hadoop-install.sh hadoop

COPY conf/*.xml /opt/hadoop/etc/hadoop/

ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR ${HADOOP_HOME}/lib/native
ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_COMMON_HOME /opt/hadoop
ENV HADOOP_HDFS_HOME /opt/hadoop
ENV HADOOP_MAPRED_HOME /opt/hadoop
ENV HADOOP_YARN_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop
ENV HADOOP_OPTS='-Djava.library.path=${HADOOP_HOME}/lib'
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH

RUN ${HADOOP_HOME}/bin/hdfs namenode -format

CMD ["/sbin/runsvdir", "-P", "/etc/service"]


