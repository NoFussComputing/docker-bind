
ARG VERSION_BIND="9.18.19-r0"

FROM --platform=$TARGETPLATFORM alpine:3.18.4


ARG VERSION_BIND


RUN \
	apk upgrade --no-cache; \
	apk add --no-cache \
		bind==${VERSION_BIND} \
		supervisor;


EXPOSE \
	53/tcp \
	53/udp
	# Others required? dnssec, secure updates, sone transfers DOT etc


HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD \
  supervisorctl status || exit 1


COPY includes/ /


CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf" ]
