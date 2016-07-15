# SFTP server

This repo provides a docker image for an SFTP server set up to
authenticate using RFC4716 public keys obtained from an LDAP server
(in turn populated by Keycloak), monitor incoming files, copy them
across to a (potentially remote) directory and send out an AMQP
notification.

## Configuration

The following environment variables and other options are available
for configuration:

### SFTP details

The container expects to find an ssh host private key in
/etc/secrets/ssh-host-key.

Incoming files are copied to the /target directory, which should be
mounted appropriately.

### LDAP details

LDAP_SERVER: location of LDAP server
LDAP_BIND_USER, LDAP_BIND_PASSWORD: server credentials
LDAP_USERS_BASE: Base DN for users in LDAP
LDAP_USERS_FILTER: LDAP search filter for users (default: (&(uid=%v)(objectclass=ldapPublicKey)))

### Messaging details

MESSAGE_BROKER_URL: URL of message broker
MESSAGE_EXCHANGE: exchange name (blank for default exchange)
MESSAGE_ROUTING_KEY: routing key (optional)

### Logging details

LOGSTASH_SERVICE_HOST, LOGSTASH_SERVICE_PORT: location of logstash server

## Test / demo

The test/ directory contains a harness which can be used to demo and
test the server.

The start.sh script will bring up two docker containers, one
containing the SFTP server and the other the supporting infrastructure
(openldap, keycloak, rabbitmq, logstash/elasticsearch/kibana).  Ports
are mapped onto the host according to the settings in config.sh.

The keycloak server is created with an 'admin' account with password
'secret', and a 'test' realm which is set up for configuring SSH
public keys for users.  The realm can be administered at
http://localhost:8080/auth/admin/test/console with the default config.

Files are sent to the target/ directory.

The test.sh script uploads a file to the demo server and verifies that
it performs as expected.  The stop.sh script stops and removes both
containers.
