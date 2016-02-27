#!/bin/sh 
#
#	install
#

set -e 

base() {

	echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk add --update rsync runit wget
	# printf "#!/bin/sh\nset -e\nexec /sbin/runsvdir -P /etc/service/ " > /usr/local/sbin/ && \
}

darkhttpd() {

	apk add darkhttpd && \
	rm -rf /var/www/localhost/ && \
	mkdir -p /var/www/ /etc/service/darkhttpd/ && \
	echo "Static cache server" > /var/www/index.html && \
	printf "#!/bin/sh\nset -e\nexec /usr/bin/darkhttpd /var/www/" > /etc/service/darkhttpd/run && \
	chmod +x /etc/service/darkhttpd/run
	# printf "#!/bin/sh\nset -e\nexec /usr/bin/darkhttpd /var/www/ --log /var/log/darkhttpd/access.log" > /etc/service/darkhttpd/run && \
}

privoxy() {
	
	apk add privoxy && \
	sed -i "s/:1000:/:65535:/" /etc/group /etc/passwd && \
	chown root:root /etc/privoxy /var/log/privoxy && \
	mkdir -p /etc/service/privoxy/ && \
	printf "#!/bin/sh\nset -e\nexec /usr/sbin/privoxy --no-daemon /etc/privoxy/config" > /etc/service/privoxy/run && \
	chmod +x /etc/service/privoxy/run
}

svlogd() {

	mkdir -p /etc/service/svlogd/ /var/log/svlogd/ && \
	printf "#!/bin/sh\nset -e\nexec svlogd -tt /var/log/svlogd/logs" > /etc/service/svlogd/run && \
	chmod +x /etc/service/svlogd/run	
}


clean() {

	rm -rf \
		/var/cache/apk/* \
		/etc/privoxy/* \
		/install/mirrors/ && \
    rm -f \
    	/etc/init.d/darkhttpd \
    	/etc/init.d/privoxy
}


$@

