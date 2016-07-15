FROM phusion/baseimage:0.9.19

ENV LDAP_USERS_FILTER (&(uid=%v)(objectclass=ldapPublicKey))
ENV LOGSTASH_SERVICE_PORT 5044

ADD sources.list.d/* /etc/apt/sources.list.d/
ADD debconf-selections /tmp/

RUN add-apt-repository ppa:healthforge.io/ppa && \
    curl https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
    apt-get -y update && \
    debconf-set-selections < /tmp/debconf-selections && \
    apt-get -y install filebeat proftpd-basic proftpd-mod-ldap proftpd-mod-sftp-ldap python3-pip && \
    pip3 install kombu && \
    mkdir -p --mode=755 /etc/proftpd/skel/inbox && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD proftpd/proftpd.conf /etc/proftpd/
ADD proftpd/run /etc/service/proftpd/

ADD monitor/run /etc/service/monitor/

ADD cron.daily/housekeeping /etc/cron.daily/

ADD filebeat/filebeat.yml /etc/filebeat/
ADD filebeat/run /etc/service/filebeat/

ADD entry.sh /sbin/

ENTRYPOINT ["entry.sh"]
CMD ["/sbin/my_init"]

EXPOSE 22
