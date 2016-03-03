#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

echo "= /install/alpine/privoxy.sh ============================================"
echo "Parameters:"
echo "RUNIT_SUPPORT=YES         to add runit support"
echo "SUPERVISORD_SUPPORT=YES   to add supervisord support"
echo "SVLOGD_ACTIVATE=YES       activate svlogd service, RUNIT_SUPPORT is required"
echo "-------------------------------------------------------------------------"

apk add --update privoxy && \
rm -rf \
    /var/cache/apk/* \
    /etc/init.d/privoxy \
    /etc/privoxy/* && \
sed -i "s/:1000:/:65535:/" /etc/group /etc/passwd && \
chown root:root /etc/privoxy /var/log/privoxy && \


if [ "${RUNIT_SUPPORT}" = "YES" ]
then

    mkdir -p /etc/service/privoxy/ && \
    printf "#!/bin/sh\nset -e\nexec /usr/sbin/privoxy --no-daemon /etc/privoxy/config" > /etc/service/privoxy/run && \
    chmod +x /etc/service/privoxy/run && 
    echo "[INFO] runit support was activated"
fi

if [ "${SUPERVISORD_SUPPORT}" = "YES" ]
then
    echo "[WARNING] The support of supervisord is not implemented yet"
fi

if  [ "${RUNIT_SUPPORT}" = "YES" ] && [ "${SVLOGD_ACTIVATE}" = "YES" ]
then
    mkdir -p /etc/service/svlogd/ /var/log/svlogd/ && \
    printf "#!/bin/sh\nset -e\nexec svlogd -tt /var/log/svlogd/logs" > /etc/service/svlogd/run && \
    chmod +x /etc/service/svlogd/run && \
    echo "[INFO] svlogd support was activated"
fi

