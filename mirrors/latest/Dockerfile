FROM alpine:latest

COPY ./scripts/install.sh /install/mirrors/install.sh

RUN /install/mirrors/install.sh base && \
	/install/mirrors/install.sh darkhttpd && \
	/install/mirrors/install.sh privoxy && \
	/install/mirrors/install.sh clean
	# /install/mirrors/install.sh svlogd && \

COPY ./conf/privoxy /etc/privoxy

CMD ["/sbin/runsvdir", "-P", "/etc/service"]


