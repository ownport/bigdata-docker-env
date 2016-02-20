FROM alpine:latest

ARG CONSUL_VERSION
ARG CONSUL_SHA256

RUN apk add --update wget && \
    wget -c --progress=dot:mega --no-check-certificate \
        https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk \
        -O /tmp/glibc-2.21-r2.apk && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
	wget -c --progress=dot:mega --no-check-certificate \
		https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
		-O /tmp/consul.zip && \    
    apk del wget && \
    echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256 && \
    sha256sum -c /tmp/consul.sha256 && \
    cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && \
    rm /tmp/glibc-2.21-r2.apk /tmp/consul.zip && \
    rm -rf /var/cache/apk/*

