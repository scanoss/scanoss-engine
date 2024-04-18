FROM debian:bookworm-slim as build

RUN \
  DEBIAN_FRONTEND=noninteractive \
    apt update && apt install --assume-yes --no-install-recommends \
      libsodium23 \
      zlib1g-dev \
      libgcrypt-dev \
      curl \
      bc \
      git \
      ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /scanoss

# Engine dependencies

# libssl
RUN curl -O http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1n-0+deb11u5_amd64.deb && \
    dpkg -i libssl1.1_1.1.1n-0+deb11u5_amd64.deb && \
    rm -rf libssl1.1_1.1.1n-0+deb11u5_amd64.deb

WORKDIR /scanoss/ldb/

ENV SUDO_USER=root

# Install ldb
RUN export LDB_PKG_URL=$(curl -s https://api.github.com/repos/scanoss/ldb/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep deb) && \
    export LDB_PKG=$(basename ${LDB_PKG_URL}) && \
    curl -LO $LDB_PKG_URL && \
    dpkg -i $LDB_PKG && \
    rm -rf $LDB_PKG

# Install engine

WORKDIR /scanoss/engine/

RUN export ENGINE_PKG_URL=$(curl -s https://api.github.com/repos/scanoss/engine/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep deb) && \
    export ENGINE_PKG=$(basename ${ENGINE_PKG_URL}) && \
    curl -LO $ENGINE_PKG_URL && \
    dpkg -i $ENGINE_PKG && \
    rm -rf $ENGINE_PKG

# Install API

WORKDIR /scanoss/api

RUN useradd --system scanoss

RUN mkdir -p /var/lib/ldb/ && \
    mkdir -p /usr/local/etc/scanoss

COPY ./scripts/* /scanoss/api/custom_scripts/

RUN export API_PKG_URL=$(curl -s https://api.github.com/repos/scanoss/api.go/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep amd64 | grep tgz) && \
    export API_PKG=$(basename ${API_PKG_URL}) && \
    curl -LO $API_PKG_URL && \
    tar -xzvf $API_PKG && \
    cp /scanoss/api/custom_scripts/* /scanoss/api/scripts/ && \
    cd /scanoss/api/scripts/ && \
    ./env-setup.sh prod -y && \
    rm -rf /scanoss/api

# Add Convenience Scripts/Tools

COPY scripts/import.sh /scanoss/scripts/


ENTRYPOINT ["bash","-c","/usr/local/bin/scanoss-go-api.sh"]