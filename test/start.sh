#!/bin/sh

docker run -d --name sftp --env-file=sftp/env -v $(pwd)/sftp/ssh:/etc/ssh:ro sftp
