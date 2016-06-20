FROM phusion/baseimage:0.9.18

ADD openldap /tmp/openldap

RUN apt-get -y update && \
    debconf-set-selections < /tmp/openldap/selections && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install slapd && \
    su openldap -s /bin/sh -c "slapadd -n 0 -l /tmp/openldap/openssh-lpk_openldap.ldif" && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD openldap/run /etc/service/openldap/

EXPOSE 389
