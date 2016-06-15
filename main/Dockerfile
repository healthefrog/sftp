FROM phusion/baseimage:0.9.18

RUN add-apt-repository ppa:healthforge.io/ppa && \
    apt-get -y update && \
    apt-get -y install proftpd-basic proftpd-mod-ldap proftpd-mod-sftp-ldap && \
    mkdir -p --mode=755 /etc/proftpd/skel/inbox && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD proftpd/proftpd.conf /etc/proftpd/
ADD proftpd/run /etc/service/proftpd/

ADD monitor/run /etc/service/monitor/

ADD cron.daily/housekeeping /etc/cron.daily/

EXPOSE 22
