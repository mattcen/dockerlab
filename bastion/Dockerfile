FROM sshtest

RUN sed  -i '1i [ `id -u` -eq 0 ] || exec ssh -oStrictHostKeyChecking=no root@"$USER"' /etc/profile
RUN sed -i '/motd/s/^/#/' /etc/pam.d/*
RUN bash -c 'for user in alice bob; \
  do adduser --gecos "" --disabled-password "$user" \
  && printf "$user\n$user\n" | passwd "$user" \
  && install -o "$user" -g "$user" -m 700 -d /home/"$user"/.ssh; \
  done'
