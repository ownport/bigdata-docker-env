FROM ownport/oracle-server-jre:8u60

ARG FLUME_VERSION

COPY ./scripts/install.sh /install/flume/install.sh

RUN /install/flume/install.sh base && \
	/install/flume/install.sh flume && \
	/install/flume/install.sh set_env && \
	/install/flume/install.sh clean


