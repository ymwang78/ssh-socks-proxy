#!/bin/bash
set -e

# MUST SET：REMOTE_HOST, REMOTE_PORT, USER
if [ -z "$REMOTE_HOST" ] || [ -z "$USER" ]; then
  echo "Must set REMOTE_HOST and USER "
  exit 1
fi

: "${REMOTE_PORT:=22}" 
: "${LOCAL_PORT:=1080}" 

SSH_OPTS="-o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ServerAliveCountMax=3"

if [ -n "$PASSWORD" ]; then
    echo "with Password"
    exec sshpass -p "$PASSWORD" autossh -M 0 -N -D 0.0.0.0:$LOCAL_PORT $SSH_OPTS $USER@$REMOTE_HOST -p $REMOTE_PORT
elif [ -n "$SSH_KEY" ]; then
    echo "with Key"
    echo "$SSH_KEY" > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
    exec autossh -M 0 -N -D 0.0.0.0:$LOCAL_PORT $SSH_OPTS -i /root/.ssh/id_rsa $USER@$REMOTE_HOST -p $REMOTE_PORT
else
    echo "Must set PASSWORD or SSH_KEY"
    exit 1
fi
