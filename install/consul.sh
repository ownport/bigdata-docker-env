#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

apk add --update wget

mkdir -p /var/run/consul/ && \
wget -c --progress=dot:mega --no-check-certificate \
	https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
	-O /tmp/consul.zip && \
echo "${CONSUL_SHA256}  /tmp/consul.zip" > /tmp/consul.sha256  && \
sha256sum -c /tmp/consul.sha256 && \
cd /bin && unzip /tmp/consul.zip && \
chmod +x /bin/consul && \
echo '[INFO] consul installation is completed'    


wget -c --progress=dot:mega --no-check-certificate \
	https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_web_ui.zip \
	-O /tmp/web-ui.zip && \
echo "${WEBUI_SHA256}  /tmp/web-ui.zip" > /tmp/web-ui.sha256  && \
sha256sum -c /tmp/web-ui.sha256 && \
cd /var/www/consul/ && \
unzip /tmp/web-ui.zip && \
echo '[INFO] consul web-ui installation is completed'    	


apk del wget 
rm -rf /var/cache/apk/* /tmp/* /install/* && \
echo '[INFO] Clearing is completed'    



