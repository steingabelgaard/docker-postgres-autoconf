ARG BASE_TAG
FROM docker.io/postgres:${BASE_TAG}
RUN localedef -i da_DK -c -f UTF-8 -A /usr/share/locale/locale.alias da_DK.UTF-8
ENV LANG da_DK.UTF-8
ENTRYPOINT [ "/autoconf-entrypoint" ]
CMD []
ENV CERTS="{}" \
    CONF_EXTRA="" \
    LAN_AUTH_METHOD=md5 \
    LAN_CONNECTION=host \
    LAN_DATABASES='["all"]' \
    LAN_HBA_TPL="{connection} {db} {user} {cidr} {meth}" \
    LAN_TLS=0 \
    LAN_USERS='["all"]' \
    WAN_AUTH_METHOD=cert \
    WAN_CONNECTION=hostssl \
    WAN_DATABASES='["all"]' \
    WAN_HBA_TPL="{connection} {db} {user} {cidr} {meth}" \
    WAN_TLS=1 \
    WAN_USERS='["all"]'
RUN apt update -y \
    && mkdir -p /etc/postgres \
    && chmod a=rwx /etc/postgres
RUN apt install -y python3-pip \
    && pip3 install --no-cache-dir \
        netifaces \
    && apt-get clean -y
COPY autoconf-entrypoint /

# Metadata
ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.vendor=steingabelgaard \
      org.label-schema.license=Apache-2.0 \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.vcs-ref="$VCS_REF" \
      org.label-schema.vcs-url="https://github.com/steingabelgaard/docker-postgres-autoconf"
