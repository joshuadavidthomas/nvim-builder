FROM ubuntu:24.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  build-essential \
  cmake \
  curl \
  gettext \
  git \
  ninja-build \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
RUN chmod 777 /workdir

COPY entrypoint.sh /workdir/
RUN chmod +x /workdir/entrypoint.sh

ENTRYPOINT ["/workdir/entrypoint.sh"]
