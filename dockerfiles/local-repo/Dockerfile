FROM alpine:latest

ARG LOCAL_REPO

RUN wget -O - http://${LOCAL_REPO}/install/alpine/runit.sh | sh -s && \
	wget -O - http://${LOCAL_REPO}/install/alpine/darkhttpd.sh | \
		RUNIT_SUPPORT=YES sh -s && \
	wget -O - http://${LOCAL_REPO}/install/alpine/privoxy.sh | \
		RUNIT_SUPPORT=YES sh -s

COPY ./conf/privoxy /etc/privoxy

CMD ["/sbin/runsvdir", "-P", "/etc/service"]


