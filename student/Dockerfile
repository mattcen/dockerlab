FROM mattcen/sshbase

RUN yes | unminimize

ENV TZ=Australia/Melbourne

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN printf 'tzdata %s select %s\n' tzdata/Areas "${TZ%/*}" tzdata/Zones/"${TZ%/*}" "${TZ#*/}" | debconf-set-selections

RUN apt-get update \
  && apt-get install -y \
  dialog tzdata man busybox nano git python3-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Speed up subsequent user package installation by pre-downloading package
# cache and required packages.
RUN apt-get update && apt-get -dy install nginx apache2 php

COPY skel/ /etc/skel/

EXPOSE 80 22
