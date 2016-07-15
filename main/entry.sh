#!/bin/sh

if [ -f /etc/secrets/ssh_host_key ]; then
    cp /etc/secrets/ssh_host_key /etc/ssh/
    chown root: /etc/ssh/ssh_host_key
    chmod 0600 /etc/ssh/ssh_host_key
fi

exec $@
