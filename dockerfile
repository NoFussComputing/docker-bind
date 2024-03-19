
ARG VERSION_BIND="9.18.24-r0"

FROM alpine:3.18.4


ARG VERSION_BIND


RUN \
  apk upgrade --no-cache; \
  apk add --no-cache \
    bind==${VERSION_BIND} \
    supervisor; \
  rm -f \
    /etc/bind/named.conf.authoritative \
    /etc/bind/named.conf.recursive \
    /etc/bind/rndc.key;


EXPOSE \
  53/tcp \
  53/udp
  # Others required? dnssec, secure updates, sone transfers DOT etc


HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD \
  supervisorctl status || exit 1


COPY includes/ /


RUN \
  chown named:named -R /etc/bind; \
  chmod 5771 /etc/bind;


CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
# CMD ["named", "-c", "/etc/bind/named.conf", "-g", "-u", "named"]
