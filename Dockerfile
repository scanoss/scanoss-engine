FROM debian:stable

RUN \
  DEBIAN_FRONTEND=noninteractive \
    apt update && apt install --assume-yes --no-install-recommends \
      build-essential \
      curl \
      git \
      libssl-dev \
      zlib1g-dev \
      unrar-free \
      #minr deps
      man make gcc libssl-dev zipmerge vim bc net-tools rsync zip p7zip-full byobu libxslt1.1 \
      php-cli unzip strace tmux valgrind ntpdate xz-utils ruby python3-pip python3-venv parted \
      xxd hexcurse ntpdate jq nload \
      #extra
      ca-certificates \
      openssl \
      wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /scanoss/

RUN git clone https://github.com/scanoss/ldb.git && \
    cd ldb && \
    make && \
    make install && \
    mkdir /var/lib/ldb


# Install miner
RUN git clone https://github.com/scanoss/minr.git && \
    cd minr && \
    make && \
    make install

RUN echo $(minr -v)

# Install engine

WORKDIR /scanoss/engine/

RUN git clone https://github.com/scanoss/engine.git && \
    cd engine && \
    make && \
    make install

RUN echo $(scanoss -v)

WORKDIR /scanoss/KB

# Sample URL mining

COPY ./mining_commands.sh mining_commands.sh

RUN git clone https://github.com/scanoss/wayuu.git && \
    cd wayuu && \
    make && \
    make install

RUN git clone https://github.com/scanoss/API.git && \
    cd API && \
    make && \
    make install

ENTRYPOINT ["/usr/bin/scanoss-api", "-d", "-f", "-b", "0.0.0.0"]
