#!/bin/sh -e

KEYCLOAK_PORT=8080
KEYCLOAK_BASE="http://localhost:$KEYCLOAK_PORT/auth"
SSH_PORT=2222

docker rm -f sftp || true
docker build -t sftp ../main

docker rm -f sftptest || true
docker build -t sftptest .

docker run -d --name sftptest -p 1389:389 -p $KEYCLOAK_PORT:8080 sftptest

mkdir -p target
docker run -d --name sftp --link sftptest:sftptest -p $SSH_PORT:22 --env-file=sftp/env -v $(pwd)/sftp/ssh:/etc/ssh:ro -v $(pwd)/target:/target sftp

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

echo -n "Uploading test file... "
env -i scp -q -F /dev/null -P $SSH_PORT -i ssh/test_id_rsa test-upload.txt test@localhost:inbox/
echo " ok"

echo -n "Waiting for file to appear in target directory... "  # tried to do this with inotifywait but it was more hassle than it was worth
while ! [ -f target/test/test-upload.txt ]; do
    sleep 1
done
diff -q test-upload.txt target/test/test-upload.txt
echo " ok"

echo "Cleaning up... "
docker exec sftp rm -r /target/test  # hack because it's owned by root
docker rm -f sftp
docker rm -f sftptest
