FROM ownport/oracle-server-jre:7u76

ARG FLUME_VERSION

COPY ./scripts/install.sh /install/flume/install.sh

RUN /install/flume/install.sh base && \
	/install/flume/install.sh flume && \
	/install/flume/install.sh set_env && \
	/install/flume/install.sh clean

COPY ./conf/log4j.properties /data/conf/log4j.properties
COPY ./scripts/manage.py /data/bin

