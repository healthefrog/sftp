FROM phusion/baseimage:0.9.18

RUN add-apt-repository ppa:healthforge.io/ppa && \
    apt-get -y update && \
    apt-get -y install proftpd-basic proftpd-mod-ldap proftpd-mod-sftp-ldap && \
    mkdir --mode=755 /etc/proftpd/skel && \
    mkdir --mode=755 /etc/proftpd/skel/inbox && \
    mkdir --mode=555 /etc/proftpd/skel/processed && \
    mkdir --mode=555 /etc/proftpd/skel/outbox && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD proftpd.conf /etc/proftpd/
ADD run /etc/service/proftpd/

EXPOSE 22
