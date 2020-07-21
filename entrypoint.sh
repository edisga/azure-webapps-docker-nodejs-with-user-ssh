#!/bin/bash
set -e

cp /etc/ssh/sshd_config /tmp
sed -i "s/SSH_PORT/$SSH_PORT/g" /tmp/sshd_config
cp /tmp/sshd_config /etc/ssh/sshd_config

sudo /usr/sbin/service ssh start
node /code/server.js
