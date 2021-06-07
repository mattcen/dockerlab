FROM mattcen/sshbase

RUN apt-get update \
  && apt-get install -y \
  && bash \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Speed up subsequent user package installation by pre-downloading package
# cache and required packages.
RUN apt-get update && apt-get -dy install nginx

EXPOSE 80 22
