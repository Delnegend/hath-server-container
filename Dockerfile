FROM alpine:3.23 AS builder

ARG HATH_VERSION

RUN apk add --no-cache unzip wget

RUN wget -O /tmp/hath-$HATH_VERSION.zip https://repo.e-hentai.org/hath/HentaiAtHome_$HATH_VERSION.zip && \
    mkdir -p /hath_extracted && \
    unzip /tmp/hath-$HATH_VERSION.zip -d /hath_extracted

FROM ibm-semeru-runtimes:open-25-jre

LABEL maintainer="Delnegend <kien@delnegend.com>"

COPY --from=builder /hath_extracted/ /opt/hath/
COPY start.sh /opt/hath/

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates tzdata && \
    apt-get autoremove -y && \
    update-ca-certificates && \
    chmod +x /opt/hath/*.sh && \
    mkdir -p /hath/cache /hath/data /hath/download /hath/log /hath/tmp && \
    chown -R ubuntu:ubuntu /opt/hath /hath

USER ubuntu

CMD ["sh","-lc","/opt/hath/start.sh || (echo 'Failing, waiting 30s...' && sleep 30s && exit 1)"]
