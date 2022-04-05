FROM mattcen/sshbase

RUN apt-get update \
  && apt-get install -y \
  busybox nano git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Speed up subsequent user package installation by pre-downloading package
# cache and required packages.
RUN apt-get update && apt-get -dy install nginx apache2

COPY skel/ /etc/skel/

EXPOSE 80 22
