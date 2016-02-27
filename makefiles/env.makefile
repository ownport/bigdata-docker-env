# --------------------------------------------------------------
#
#	Environment
#

PROXY_HOST := $(shell docker inspect -f "{{ json .NetworkSettings.Networks.bignet.IPAddress }}" mirrors | sed "s/\"//g")
HTTP_PROXY := $(if ${PROXY_HOST},"http://${PROXY_HOST}:8118","")
# not implemented, HTTPS_PROXY := $(if ${PROXY_HOST},"https://${PROXY_HOST}:8118","")


# --------------------------------------------------------------
#
#	BigNet Docker network
#

create-network:
	docker network create bignet

show-network:
	@ docker network inspect bignet

remove-network:
	docker network rm bignet

# --------------------------------------------------------------
#
#	Shipyard
#

build-shipyard:
	docker pull shipyard/shipyard:latest


# --------------------------------------------------------------
#
#	etcd
#
build-etcd-2.2.5:
	docker build -t 'ownport/etcd:2.2.5' \
		--build-arg ETCD_VERSION='2.2.5' \
		etcd


# --------------------------------------------------------------
#
#	consul
#

build-consul-0.6.3:
	docker build -t 'ownport/consul:0.6.3' \
		--build-arg CONSUL_VERSION='0.6.3' \
		--build-arg CONSUL_SHA256='b0532c61fec4a4f6d130c893fd8954ec007a6ad93effbe283a39224ed237e250' \
		--build-arg WEBUI_SHA256='93bbb300cacfe8de90fb3bd5ede7d37ae6ce014898edc520b9c96a676b2bbb72' \
		consul/

run-consul-0.6.3-cli:
	docker run -ti --rm --name 'consul-cli' \
		-h consul-server \
		ownport/consul:0.6.3 \
		/bin/sh

run-consul-0.6.3-server:
	docker run -ti --rm --name 'consul-server' \
		-h consul-server \
		--net bignet \
		ownport/consul:0.6.3 \
		consul agent -server -bootstrap \
			-data-dir=/var/run/consul/ \
			-ui -ui-dir=/var/www/consul \
			-dc=bignet -client=172.19.0.2

# --------------------------------------------------------------
#
#	BigData mirrors
#

build-mirrors:
	mkdir -p $(shell pwd)/volumes/mirrors/apache-repo 
	mkdir -p $(shell pwd)/volumes/mirrors/alpine-repo 
	mkdir -p $(shell pwd)/volumes/mirrors/oracle-repo 
	docker build -t 'ownport/bigdata-mirrors:latest' \
		--build-arg HTTP_PROXY=${HTTP_PROXY} \
		mirrors/latest

run-mirrors-cli:
	docker run -ti --rm --name 'mirrors' \
		-h mirrors \
		--net bignet \
		-v $(shell pwd)/volumes/mirrors:/var/www \
		-v $(shell pwd)/mirrors/latest/scripts/mirrors:/data/mirrors/scripts \
		-v $(shell pwd)/bin/run-as.sh:/usr/local/sbin/run-as.sh \
		ownport/bigdata-mirrors:latest \
		/usr/local/sbin/run-as.sh $(shell whoami) $(shell id -u) /bin/sh

run-mirrors:
	docker run -d --name 'mirrors' \
		-h mirrors \
		--net bignet \
		-v $(shell pwd)/volumes/mirrors:/var/www \
		ownport/bigdata-mirrors:latest


