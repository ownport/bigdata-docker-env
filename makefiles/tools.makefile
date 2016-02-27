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
