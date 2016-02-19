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
#	Hadoop
#

build-hadoop-2.7.2:
	docker build -t 'ownport/hadoop:2.7.2-jdk18' \
		--build-arg HADOOP_VERSION='2.7.2' \
		hadoop/

run-hadoop-2.7.2:
	docker run -ti --rm --name 'hadoop-272' -h hadoop-272 ownport/hadoop:2.7.2-jdk18

run-hadoop-2.7.2-cli:
	docker run -ti --rm --name 'hadoop-272' -h hadoop-272 ownport/hadoop:2.7.2-jdk18 /bin/bash --login

attach-hadoop-2.7.2:
	docker exec -ti hadoop-272 /bin/bash --login


# --------------------------------------------------------------
#
#	service commands
#

stop-all-containers:
	docker stop `docker ps -a -q`

remove-exited-containers:
	docker rm `docker ps -a | grep Exited | cut -d " " -f 1`

remove-all-containers: stop-all-containers
	docker rm `docker ps -a -q`

remove-none-images:
	docker rmi $$(docker images | grep "^<none>" | awk '{print $$3}')

show-consul-ips:
	@curl -s http://$$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' consul-server):8500/v1/catalog/nodes | python -mjson.tool
	@echo

show-docker-images:
	docker images

