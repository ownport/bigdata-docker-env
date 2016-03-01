# --------------------------------------------------------------
#
#	simple HTTP server
#
build-darkhttpd:
	docker build -t 'ownport/darkhttpd:latest' dockerfiles/darkhttpd/

run-bigdata-repo:
	docker run -d -v $(shell pwd)/:/data \
		--name bigdata-repo \
		-h bigdata-repo \
		ownport/darkhttpd:latest \
		darkhttpd /data


# --------------------------------------------------------------
#
#	service commands
#

stop-all-containers:
	docker stop `docker ps -a -q`

remove-all-containers: stop-all-containers
	docker rm `docker ps -a -q`

remove-exited-containers:
	docker rm `docker ps -a | grep Exited | cut -d " " -f 1`

remove-none-images:
	docker rmi $$(docker images | grep "^<none>" | awk '{print $$3}')
