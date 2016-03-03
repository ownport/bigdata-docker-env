#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

echo "= /install/alpine/darkhttpd.sh ============================================"
echo "Parameters:"
echo "RUNIT_SUPPORT=YES         to add runit support"
echo "SUPERVISORD_SUPPORT=YES   to add supervisord support"
echo "----------------------------------------------------------------------"

apk add --update darkhttpd && \
rm -rf /var/cache/apk/* /etc/init.d/darkhttpd && \
mkdir -p /var/www/ && \
echo "Static cache server" > /var/www/index.html && \


if [ "${RUNIT_SUPPORT}" = "YES" ]
then

	mkdir -p /etc/service/darkhttpd/ && \
	printf "#!/bin/sh\nset -e\nexec /usr/bin/darkhttpd /var/www/" > /etc/service/darkhttpd/run && \
	chmod +x /etc/service/darkhttpd/run && \
    echo "[INFO] runit support was activated"
fi

if [ "${SUPERVISORD_SUPPORT}" = "YES" ]
then
    echo "[WARNING] The support of supervisord is not implemented yet"
fi

