FROM phusion/baseimage:0.9.19

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV KEYCLOAK_VERSION 1.9.8.Final

ADD sources.list.d/* /etc/apt/sources.list.d/
ADD debconf-selections /tmp/
ADD openldap/*.ldif /tmp/
ADD http://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz /opt/
ADD ssl/certs/ca-certificates.crt /tmp/

RUN add-apt-repository -y ppa:webupd8team/java && \
    curl https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    apt-get -y update && \
    debconf-set-selections < /tmp/debconf-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install elasticsearch kibana logstash oracle-java8-installer rabbitmq-server slapd && \
    rm -r /etc/ldap/slapd.d/* && \
    su openldap -s /bin/sh -c "slapadd -n 0 -F /etc/ldap/slapd.d -l /tmp/config.ldif && slapadd -n 1 -l /tmp/data.ldif" && \
    cd /opt && tar -xf keycloak-$KEYCLOAK_VERSION.tar.gz && rm keycloak-$KEYCLOAK_VERSION.tar.gz && \
    /opt/keycloak-$KEYCLOAK_VERSION/bin/add-user-keycloak.sh -r master -u admin -p secret && \
    keytool -import -noprompt -file /tmp/ca-certificates.crt -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD elasticsearch/config /usr/share/elasticsearch/
ADD elasticsearch/run /etc/service/elasticsearch/

ADD logstash/logstash.conf /etc/logstash/
ADD logstash/run /etc/service/logstash/

ADD keycloak/theme /opt/keycloak-$KEYCLOAK_VERSION/themes/healthforge
ADD keycloak/run /etc/service/keycloak/

ADD kibana/run /etc/service/kibana/

ADD openldap/run /etc/service/openldap/

ADD rabbitmq/rabbitmq.config /etc/rabbitmq/
ADD rabbitmq/run /etc/service/rabbitmq/

EXPOSE 389 636 5601 5671 5672 8080
