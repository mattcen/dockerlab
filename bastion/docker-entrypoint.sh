#!/bin/bash

if [ -n "$ROOT_AUTHORIZED_KEYS" ]
then
  echo "$ROOT_AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
fi

h=/data/home
while IFS=\| read -r user host password
do
  adduser --gecos "" --disabled-password "$user"
  printf "$password\n$password\n" | passwd "$user"
  printf 'Host mine\n  Hostname %s\nStrictHostKeyChecking no\n' "$host" > "$h/$user"/.ssh/config
  cat /root/secrets/keys/"$user" > "$h/$user"/.ssh/id_rsa
  chmod 600 "$h/$user"/.ssh/id_rsa
  chown -R "$user": "$h/$user"/.ssh
done < /root/secrets/users.psv

mkdir -p /data/etc/ssh &&
  ssh-keygen -A -f /data

exec "$@"
