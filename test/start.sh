#!/bin/sh -e

docker rm -f sftp || true
docker build -t sftp ../main

docker rm -f sftptest || true
docker build -t sftptest .

docker run -d --name sftptest -p 1389:389 -p 8080:8080 sftptest
docker run -d --name sftp --link sftptest:sftptest -p 2222:22 --env-file=sftp/env -v $(pwd)/sftp/ssh:/etc/ssh:ro sftp
