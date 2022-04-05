FROM ubuntu:22.04

VOLUME /data

RUN apt-get update \
  && apt-get install -y openssh-server sudo vim less \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/%sudo/s/ALL$/NOPASSWD:&/' /etc/sudoers \
  && mkdir /var/run/sshd \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
  && install -m 700 -d /etc/skel/.ssh /root/.ssh \
  && touch /etc/skel/.ssh/authorized_keys \
  && echo 'DHOME=/data/home\nEXTRA_GROUPS=sudo\nADD_EXTRA_GROUPS=1\n' >> /etc/adduser.conf

COPY sshd_config /etc/ssh/sshd_config.d/docker.conf

COPY docker-entrypoint.sh .
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-eD"]
