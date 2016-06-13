FROM phusion/baseimage:0.9.18

RUN add-apt-repository ppa:healthforge.io/ppa && \
    apt-get -y update && \
    apt-get -y install proftpd-basic proftpd-mod-ldap proftpd-mod-sftp-ldap && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD proftpd.conf /etc/proftpd/
ADD run /etc/service/proftpd/

EXPOSE 22
