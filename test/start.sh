#!/bin/sh

docker run --env-file=proftpd/env -v $(pwd)/proftpd/ssh:/etc/ssh proftpd
