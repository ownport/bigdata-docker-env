#!/bin/sh

set -eo pipefail
[[ "$TRACE" ]] && set -x || :

echo "= /install/alpine/sshd.sh ============================================"
echo "Parameters:"
echo "RUNIT_SUPPORT=YES         to add runit support"
echo "SUPERVISORD_SUPPORT=YES   to add supervisord support"
echo "PASSWORDLESS_MODE=YES     to set passwordless mode"
echo "----------------------------------------------------------------------"

apk add --update openssh && rm -rf /var/cache/apk/* && \
/usr/bin/ssh-keygen -A

if [ "${RUNIT_SUPPORT}" = "YES" ]
then

    mkdir -p /etc/service/sshd && \
    printf "#!/bin/sh\nexec /usr/sbin/sshd -D -f /etc/ssh/sshd_config" > /etc/service/sshd/run && \
    chmod +x /etc/service/sshd/run && \
    echo "[INFO] runit support was activated"
fi

if [ "${SUPERVISORD_SUPPORT}" = "YES" ]
then
    echo "[WARNING] The support of supervisord is not implemented yet"
fi

if [ "${PASSWORDLESS_MODE}" = "YES" ]
then

    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
fi