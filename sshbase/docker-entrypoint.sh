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
    unset AUTHORIZED_KEYS
  fi
  if [ -n "$PWHASH" ]
  then
    printf "$USERNAME:$PWHASH" | chpasswd -e
    unset PWHASH
  fi
  unset USERNAME
else
  echo "Missing environment variable(s):"
  echo "  USERNAME:        username of new user managing this container"
  echo "  AUTHORIZED_KEYS: ssh public key(s)"
  echo "  PWHASH:          hash of user's desired password"
fi

mkdir -p /data/etc/ssh &&
  ssh-keygen -A -f /data

# Execute the CMD from the Dockerfile:
exec "$@"
