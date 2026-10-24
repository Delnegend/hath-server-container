#!/bin/sh

if [ "${UMASK:-UNSET}" != "UNSET" ]; then
    umask "$UMASK"
fi

rm -f /hath/data/client_login && echo "Old client_login file removed"
printf '%s-%s' "${HATH_CLIENT_ID}" "${HATH_CLIENT_KEY}" >> /hath/data/client_login && echo "New client_login file created"

exec java -jar /opt/hath/HentaiAtHome.jar \
    --cache-dir=/hath/cache               \
    --data-dir=/hath/data                 \
    --download-dir=/hath/download         \
    --log-dir=/hath/log                   \
    --temp-dir=/hath/tmp                  \
    --disable-ip-origin-check