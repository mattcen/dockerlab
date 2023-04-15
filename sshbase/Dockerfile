FROM ubuntu:22.04 as sshbase

VOLUME /data

RUN apt-get update \
  && apt-get install -y openssh-server \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
  && install -m 700 -d /etc/skel/.ssh /root/.ssh \
  && touch /etc/skel/.ssh/authorized_keys \
  && echo 'DHOME=/data/home\n' >> /etc/adduser.conf

COPY sshd_config /etc/ssh/sshd_config.d/docker.conf

COPY docker-entrypoint.sh .
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-eD"]

FROM sshbase as sshprivileged

RUN apt-get update \
  && apt-get install -y sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/%sudo/s/ALL$/NOPASSWD:&/' /etc/sudoers \
  && echo 'EXTRA_GROUPS=sudo\nADD_EXTRA_GROUPS=1\n' >> /etc/adduser.conf

FROM sshprivileged as student

RUN yes | unminimize

ENV TZ=Australia/Melbourne

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN printf 'tzdata %s select %s\n' tzdata/Areas "${TZ%/*}" tzdata/Zones/"${TZ%/*}" "${TZ#*/}" | debconf-set-selections

RUN apt-get update \
  && apt-get install -y \
  vim less dialog tzdata man busybox nano git python3-venv python-is-python3 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Speed up subsequent user package installation by pre-downloading package
# cache and required packages.
RUN apt-get update && apt-get -dy install nginx apache2 php

COPY skel/ /etc/skel/

EXPOSE 80 22
