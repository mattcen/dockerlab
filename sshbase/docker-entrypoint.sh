#!/bin/sh

if [ -n "$ROOT_AUTHORIZED_KEYS" ]
then
  echo "$ROOT_AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
fi

if [ -n "$AUTHORIZED_KEYS" ] && [ -n "$USERNAME" ]
then
  mkdir -p /data/home
  adduser --gecos "" --disabled-password "$USERNAME"
  #install -o "$USERNAME" -g "$USERNAME" -m 700 -d /home/"$USERNAME"/.ssh

  echo "$AUTHORIZED_KEYS" > /data/home/"$USERNAME"/.ssh/authorized_keys
  #chown "$USERNAME": /home/"$USERNAME"/.ssh/authorized_keys
  #adduser "$USERNAME" sudo
else
  echo "Missing environment variables:"
  echo "  USERNAME:        username of new user managing this container"
  echo "  AUTHORIZED_KEYS: ssh public key(s)"
  #echo "Abnormal exit."
  #exit 1
fi

mkdir -p /data/etc/ssh &&
  ssh-keygen -A -f /data
#sshd -eD

# Execute the CMD from the Dockerfile:
exec "$@"
