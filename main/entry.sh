#!/bin/sh

if [ -f /etc/secrets/ssh-host-key ]; then
    cp /etc/secrets/ssh-host-key /etc/ssh/ssh_host_key
    chown root: /etc/ssh/ssh_host_key
    chmod 0600 /etc/ssh/ssh_host_key
fi

exec $@
