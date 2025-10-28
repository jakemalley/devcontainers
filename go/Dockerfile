
ARG GO_VERSION=1.25.1

FROM library/golang:${GO_VERSION} AS golang
FROM builder_base_image AS base

COPY --chown=root:root --from=golang /usr/local/go /usr/local/go

ENV \
    GOPATH=/home/code/go \
    PATH="${PATH}:/usr/local/go/bin:/home/code/go/bin"
RUN \
    mkdir -p "${GOPATH}" && \
    chown code:code "${GOPATH}"


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
    go install github.com/a-h/templ/cmd/templ@latest && \
    go install github.com/air-verse/air@latest && \
    go install github.com/go-task/task/v3/cmd/task@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install other tools
FROM base AS tools
# Installing unzip so we can download (and unzip!) some of the tools
RUN \
    apt update && apt install -y unzip && \
    apt clean all && rm -rf /var/lib/apt/lists

RUN \
    mkdir -p /tools/bin /tools/include && \
    ln -s /usr/bin/fdfind /tools/bin/fd && \
    curl -fsSL "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-arm64" \
      -o /tools/bin/tailwindcss && \
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz" | tar zxf - -C /tools/bin/ && \
    curl -fsSL "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" \
      -o /tools/bin/jq && \
    curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64" \
      -o /tools/bin/yq && \
    curl -fsSL "https://github.com/protocolbuffers/protobuf/releases/download/v30.2/protoc-30.2-linux-x86_64.zip" \
       -o /tmp/protoc-30.2-linux-x86_64.zip && unzip /tmp/protoc-30.2-linux-x86_64.zip -d /tools && \
    chmod +x /tools/bin/*


# Final stage for the devcontainer
FROM base AS dev
COPY --chown=code:code --from=tools-go /home/code/go/bin/* /home/code/go/bin/
COPY --chown=root:root --from=tools /tools/include /usr/local/include/
COPY --chown=root:root --from=tools /tools/bin /usr/local/bin/

USER code