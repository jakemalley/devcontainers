ARG BASE_IMAGE=library/debian
ARG BASE_IMAGE_TAG=stable-slim

FROM library/docker:cli AS docker-cli
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS base

ARG BASE_PACKAGES="\
    sudo \
    zsh \
    vim \
    ca-certificates \
    locales \
    tzdata \
    curl wget \
    make \
    git \
    sqlite3 \
    fd-find \
    binutils \
    bzip2 bsdiff \
    zip unzip \
"

ENV \
    TZ=Europe/London \
    TERM=xterm-256color \
    LANG=en_GB.UTF-8 \
    LC_ALL=en_GB.UTF-8

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    echo "${TZ}" > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${LANG} UTF-8" > /etc/locale.gen && \
    echo "LANG=${LANG}" > /etc/locale.conf && \
    apt update && apt -y full-upgrade && \
    apt install -y ${BASE_PACKAGES} && \
    apt clean all && rm -rf /var/lib/apt/lists && \
    ln -s /usr/bin/fdfind /usr/local/bin/fd && \
    locale-gen $LANG && \
    groupadd -g 500 --system code && \
    useradd -u 500 -g 500 --system -s /usr/bin/zsh -d /home/code --create-home code && \
    echo "code ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/code && \
    mkdir -p /workspaces && chown code:code /workspaces

RUN \
  git clone https://github.com/ohmyzsh/ohmyzsh.git /home/code/.oh-my-zsh && \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/code/.oh-my-zsh/custom/themes/powerlevel10k && \
  chown -R code:code /home/code/.oh-my-zsh

COPY --chown=root:root --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker-compose /usr/local/bin/
COPY --chown=code:code ./home/* /home/code/
WORKDIR /workspaces