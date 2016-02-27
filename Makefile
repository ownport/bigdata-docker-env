# --------------------------------------------------------------
#
#	Environment
#

PROXY_HOST := $(shell docker inspect -f "{{ json .NetworkSettings.Networks.bignet.IPAddress }}" mirrors | sed "s/\"//g")
HTTP_PROXY := $(if ${PROXY_HOST},"http://${PROXY_HOST}:8118","")
# not implemented, HTTPS_PROXY := $(if ${PROXY_HOST},"https://${PROXY_HOST}:8118","")


# --------------------------------------------------------------
#
#	Java
#

build-oracle-server-jre-7u76:
	docker build -t 'ownport/oracle-server-jre:7u76' \
		--build-arg JAVA_PACKAGE='server-jre' \
		--build-arg JAVA_VERSION='7u76' \
		--build-arg JAVA_VERSION_BUILD='13' \
		java/oracle/

build-oracle-server-jre-8u60:
	docker build -t 'ownport/oracle-server-jre:8u60' \
		--build-arg JAVA_PACKAGE='server-jre' \
		--build-arg JAVA_VERSION='8u60' \
		--build-arg JAVA_VERSION_BUILD='27' \
		java/oracle/

# --------------------------------------------------------------
#
#	Flume
#

build-flume-1.5.0:
	docker build -t 'ownport/flume:1.5.0-jdk18' \
		--build-arg FLUME_VERSION='1.5.0' \
		flume

run-flume-1.5.0-cli:
	docker run -ti --rm --name 'flume-150' \
		ownport/flume:1.5.0-jdk18 \
		/bin/sh


# --------------------------------------------------------------
#
#	Hadoop
#

build-hadoop-2.7.2:
	docker build -t 'ownport/hadoop:2.7.2-jdk18' \
		--build-arg HADOOP_VERSION='2.7.2' \
		hadoop/

run-hadoop-2.7.2:
	docker run -ti --rm --name 'hadoop-272' \
		-h hadoop-272 \
		--net bignet \
		ownport/hadoop:2.7.2-jdk18

run-hadoop-2.7.2-cli:
	echo ${HTTP_PROXY} ${HTTPS_PROXY}
	docker run -ti --rm --name 'hadoop-272' \
		-h hadoop-272 \
		--net bignet \
		ownport/hadoop:2.7.2-jdk18 \
		/bin/bash --login

attach-hadoop-2.7.2:
	docker exec -ti hadoop-272 /bin/bash --login



