FROM phusion/baseimage:0.9.18

ENV LDAP_USERS_FILTER (&(uid=%v)(objectclass=ldapPublicKey))

RUN add-apt-repository ppa:healthforge.io/ppa && \
    apt-get -y update && \
    apt-get -y install proftpd-basic proftpd-mod-ldap proftpd-mod-sftp-ldap python3-pip && \
    pip3 install kombu && \
    mkdir -p --mode=755 /etc/proftpd/skel/inbox && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD proftpd/proftpd.conf /etc/proftpd/
ADD proftpd/run /etc/service/proftpd/

ADD monitor/run /etc/service/monitor/

ADD cron.daily/housekeeping /etc/cron.daily/

EXPOSE 22
