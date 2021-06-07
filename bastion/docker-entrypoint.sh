#!/bin/bash

while IFS=\| read -r user host password
do adduser --gecos "" --disabled-password "$user"
  printf "$password\n$password\n" | passwd "$user"
  mkdir /home/"$user"/.ssh
  printf 'Host mine\n  Hostname %s\n' "$host" > /home/"$user"/.ssh/config
  cat /root/secrets/keys/"$user" > /home/"$user"/.ssh/id_rsa
  chmod 600 /home/"$user"/.ssh/id_rsa
  chmod 700 /home/"$user"/.ssh
  chown -R "$user": /home/"$user"/.ssh
done < /root/secrets/users.psv

exec "$@"
