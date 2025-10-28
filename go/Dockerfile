ARG GO_VERSION=latest
FROM library/golang:${GO_VERSION} AS golang
FROM builder_tools_image AS tools
FROM builder_tools_go_image AS tools-go
FROM builder_base_image AS base

COPY --chown=root:root --from=golang /usr/local/go /usr/local/go
COPY --chown=root:root --from=tools /tools/include /usr/local/include/
COPY --chown=root:root --from=tools /tools/bin/* /usr/local/bin/
COPY --chown=root:root --from=tools-go /go/bin/* /usr/local/bin/

ENV \
    GOPATH=/home/code/go \
    PATH="${PATH}:/usr/local/go/bin:/home/code/go/bin"

USER code

RUN \
    mkdir -p "${GOPATH}" && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/cweill/gotests/gotests@v1.6.0 && \
    go install github.com/fatih/gomodifytags@v1.17.0 && \
    go install github.com/josharian/impl@v1.4.0 && \
    go install github.com/haya14busa/goplay/cmd/goplay@v1.0.0 && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest
