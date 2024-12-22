ARG BASE_IMAGE=library/debian
ARG BASE_IMAGE_TAG=stable-slim

ARG GO_VERSION=1.23.4

FROM library/docker:cli AS docker-cli
FROM library/golang:${GO_VERSION} AS golang
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS base

COPY --chown=root:root --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker-compose /usr/local/bin/
COPY --chown=root:root --from=golang /usr/local/go /usr/local/go

ENV \
    TZ=Europe/London \
    GOPATH=/home/code/go \
    PATH="${PATH}:/usr/local/go/bin:/home/code/go/bin" \
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
    apt install -y bash sudo curl wget make git fd-find ca-certificates locales tzdata && \
    apt clean all && rm -rf /var/lib/apt/lists && \
    locale-gen $LANG && \
    groupadd -g 500 --system code && \
    useradd -u 500 -g 500 --system -s /bin/bash -d /home/code --create-home code && \
    echo "PS1='\u:\w\$ '" >> /home/code/.bashrc && \
    echo "code ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/code && \
    mkdir -p "${GOPATH}" /workspaces && \
    chown code:code "${GOPATH}" /workspaces

# Install Go tools using Golang cli
FROM base AS tools-go
RUN \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/cweill/gotests/gotests@v1.6.0 && \
    go install github.com/fatih/gomodifytags@v1.17.0 && \
    go install github.com/josharian/impl@v1.4.0 && \
    go install github.com/haya14busa/goplay/cmd/goplay@v1.0.0 && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest && \
    go install github.com/a-h/templ/cmd/templ@latest

# Install other tools
FROM base AS tools
RUN \
    mkdir -p /tools && \
    ln -s /usr/bin/fdfind /tools/fd && \
    curl -fsSL "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-arm64" \
      -o /tools/tailwindcss && \
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz" | tar zxf - -C /tools/ && \
    curl -fsSL "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" \
      -o /tools/jq && \
    curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64" \
      -o /tools/yq && \
    chmod +x /tools/*

# Final stage for the devcontainer
FROM base AS dev
COPY --chown=code:code --from=tools-go /home/code/go/bin/* /home/code/go/bin/
COPY --chown=root:root --from=tools /tools/* /usr/local/bin/
COPY ./home/* /home/code/

WORKDIR /workspaces
USER code