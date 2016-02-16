oracle-server-jre-7u76:
	docker build -t 'ownport/oracle-server-jre:7u76' \
		--build-arg JAVA_PACKAGE='server-jre' \
		--build-arg JAVA_VERSION='7u76' \
		--build-arg JAVA_VERSION_BUILD='13' \
		java/oracle/

oracle-server-jre-8u60:
	docker build -t 'ownport/oracle-server-jre:8u60' \
		--build-arg JAVA_PACKAGE='server-jre' \
		--build-arg JAVA_VERSION='8u60' \
		--build-arg JAVA_VERSION_BUILD='27' \
		java/oracle/

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

