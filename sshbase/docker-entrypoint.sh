#!/bin/sh

if [ -n "$ROOT_AUTHORIZED_KEYS" ]
then
  echo "$ROOT_AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
fi

if [ -n "$USERNAME" ]
then
  mkdir -p /data/home
  adduser --gecos "" --disabled-password "$USERNAME"

  if [ -n "$AUTHORIZED_KEYS" ]
  then
    echo "$AUTHORIZED_KEYS" > /data/home/"$USERNAME"/.ssh/authorized_keys
  fi
  # Set the password to the same as the username
  printf "$USERNAME\n$USERNAME\n" | passwd "$USERNAME"
else
  echo "Missing environment variable(s):"
  echo "  USERNAME:        username of new user managing this container"
  echo "  AUTHORIZED_KEYS: ssh public key(s)"
fi

mkdir -p /data/etc/ssh &&
  ssh-keygen -A -f /data
#sshd -eD

# Execute the CMD from the Dockerfile:
exec "$@"
