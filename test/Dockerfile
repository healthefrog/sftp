FROM phusion/baseimage:0.9.18

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV KEYCLOAK_VERSION 1.9.8.Final

ADD debconf-selections /tmp/
ADD openldap/*.ldif /tmp/
ADD http://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz /opt/

RUN add-apt-repository -y ppa:webupd8team/java && \
    apt-get -y update && \
    debconf-set-selections < /tmp/debconf-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install oracle-java8-installer rabbitmq-server slapd && \
    su openldap -s /bin/sh -c "slapadd -n 0 -l /tmp/config.ldif && slapadd -n 1 -l /tmp/data.ldif" && \
    cd /opt && tar -xf keycloak-$KEYCLOAK_VERSION.tar.gz && rm keycloak-$KEYCLOAK_VERSION.tar.gz && \
    /opt/keycloak-$KEYCLOAK_VERSION/bin/add-user-keycloak.sh -r master -u admin -p secret && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD keycloak/theme /opt/keycloak-$KEYCLOAK_VERSION/themes/healthforge
ADD rabbitmq/rabbitmq.config /etc/rabbitmq/

ADD openldap/run /etc/service/openldap/
ADD keycloak/run /etc/service/keycloak/
ADD rabbitmq/run /etc/service/rabbitmq/

EXPOSE 389 5672 8080
