#!/bin/sh -e

. ./config.sh

docker rm -f sftp || true
docker build -t sftp ../main

docker rm -f sftptest || true
docker build -t sftptest .

docker run -d --name sftptest -p $KIBANA_PORT:5601 -p $AMQP_PORT:5672 -p $KEYCLOAK_PORT:8080 -v $(pwd)/ssl:/etc/ssl:ro sftptest

mkdir -p target
docker run -d --name sftp --link sftptest:sftptest -p $SSH_PORT:22 --env-file=sftp/env -v $(pwd)/sftp/ssh:/etc/ssh:ro -v $(pwd)/ssl:/etc/ssl:ro -v $(pwd)/target:/target sftp

echo

echo -n "Waiting for keycloak to start..."
while ! curl -s -I -f $KEYCLOAK_BASE >/dev/null; do
    echo -n .
    sleep 1
done
echo " ok"

echo -n "Requesting token... "
TKN=$(curl -s "$KEYCLOAK_BASE/realms/master/protocol/openid-connect/token" \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -d "username=admin" \
 -d 'password=secret' \
 -d 'grant_type=password' \
 -d 'client_id=admin-cli' | jq -r '.access_token')
echo " ok"

echo -n "Creating test realm... "
curl -s "$KEYCLOAK_BASE/admin/realms" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer $TKN" \
 --data-binary @keycloak/realm.json
echo " ok"

echo -n "Creating test user... "
curl  "$KEYCLOAK_BASE/admin/realms/test/users" \
 -H "Content-Type: application/json" \
 -H "Authorization: Bearer $TKN" \
 --data-binary @keycloak/user.json
echo " ok"
